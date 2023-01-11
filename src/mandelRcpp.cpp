//* Calculate Mandelbrot fractal in Rcpp *//

#include <RcppArmadillo.h>
// [[Rcpp::depends(RcppArmadillo)]]
#include <cmath>
using namespace Rcpp;

#ifdef _OPENMP
#include <omp.h>
#endif
// [[Rcpp::plugins(openmp)]]
// [[Rcpp::plugins(cpp14)]]

// [[Rcpp::export]]
arma::mat mandelRcpp(const double x_min, const double x_max, const double y_min, const double y_max,
                         const int res_x, const int res_y, const int nb_iter) {
  arma::mat ret(res_x, res_y);
  const double x_step = (x_max - x_min) / res_x;
  const double y_step = (y_max - y_min) / res_y;
  int r,c;
#pragma omp parallel for shared(ret) schedule(dynamic) collapse(2)
  for (r = 0; r < res_y; r++) {
    for (c = 0; c < res_x; c++) {
      double zx = 0.0, zy = 0.0, new_zx;
      double cx = x_min + c*x_step, cy = y_min + r*y_step;
      int n = 0;
      int n0 = 0;
      double q = (cx-0.25)*(cx-0.25) + cy*cy;
      if((q*(q+(cx-0.25)))<(0.25*cy*cy)) { n0 = nb_iter; //* cardioid test *//
         }
      for (n=n0;  (zx*zx + zy*zy < 4.0 ) && ( n < nb_iter ); n++ ) {
        new_zx = zx*zx - zy*zy + cx;
        zy = 2.0*zx*zy + cy;
        zx = new_zx;
      }
      ret(c,r) = n;
    }
  }
  return ret;
}




//* SIMD vectorized version *//
#if defined ( __AVX512F__ ) || defined ( __AVX512__ )
static const int SIMD_SIZE = 64;
#elif defined ( __AVX2__ )
static const int SIMD_SIZE = 32;
#else
static const int SIMD_SIZE = 16;
#endif

static const int VSI_SIZE = SIMD_SIZE/sizeof(int32_t);
static const int VLI_SIZE = SIMD_SIZE/sizeof(int64_t);
static const int VDF_SIZE = SIMD_SIZE/sizeof(double);

#if defined(__clang__)
typedef int32_t vsi __attribute__ ((ext_vector_type(VSI_SIZE)));
typedef int64_t vli __attribute__ ((ext_vector_type(VLI_SIZE)));
typedef double  vdf __attribute__ ((ext_vector_type(VDF_SIZE)));
#else
typedef int32_t vsi __attribute__ ((vector_size (SIMD_SIZE)));
typedef int64_t vli __attribute__ ((vector_size (SIMD_SIZE)));
typedef double  vdf __attribute__ ((vector_size (SIMD_SIZE)));
#endif

static bool any(vli const & x) {
  for(int i=0; i<VLI_SIZE; i++) if(x[i]) return true;
  return false;
}

static vsi compress(vli const & lo, vli const & hi) {
  vsi lo2 = (vsi)lo, hi2 = (vsi)hi, z;
  for(int i=0; i<VLI_SIZE; i++) z[i+0*VLI_SIZE] = lo2[2*i];
  for(int i=0; i<VLI_SIZE; i++) z[i+1*VLI_SIZE] = hi2[2*i];
  return z;
}

// [[Rcpp::export]]
IntegerVector mandelRcpp2(double x_min, double x_max, double y_min,  double y_max, int res_x, int res_y, int nb_iter) {
  IntegerVector out(res_x*res_y);
  vdf x_minv = x_min - (vdf){}, y_minv = y_min - (vdf){};
  vdf x_stepv = (x_max - x_min)/res_x - (vdf){}, y_stepv = (y_max - y_min)/res_y - (vdf){};
  double a[VDF_SIZE] __attribute__ ((aligned(SIMD_SIZE)));
  for(int i=0; i<VDF_SIZE; i++) a[i] = 1.0*i;
  vdf vi0 = *(vdf*)a;
  
#pragma omp parallel for schedule(dynamic) collapse(2)
  for (int r = 0; r < res_y; r++) {
    for (int c = 0; c < res_x/(VSI_SIZE); c++) {
      vli nv[2] = {0 - (vli){}, 0 - (vli){}};
      for(int j=0; j<2; j++) {
        vdf c2 = 1.0*VDF_SIZE*(2*c+j) + vi0;
        vdf zx = 0.0 - (vdf){}, zy = 0.0 - (vdf){}, new_zx;
        vdf cx = x_minv + c2*x_stepv, cy = y_minv + r*y_stepv;
        vli t = -1 - (vli){};
        for (int n = 0; any(t = zx*zx + zy*zy < 4.0) && n < nb_iter; n++, nv[j] -= t) {
          new_zx = zx*zx - zy*zy + cx;
          zy = 2.0*zx*zy + cy;
          zx = new_zx;
        }
      }
      vsi sp = compress(nv[0], nv[1]);
      memcpy(&out[r*res_x + VSI_SIZE*c], (int*)&sp, SIMD_SIZE);
    }
  }
  return out;
}
  
  


//* smooth colouring might be worth implementing *//
//*  cf see also https://leamare.medium.com/experiment-with-mandelbrot-set-and-d-language-fdda4606ce9b for strategy to get smooth shading *//

