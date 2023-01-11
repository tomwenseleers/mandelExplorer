//* Histogram equalization of a vector *//
//* still not working as expected - needs to be debugged *//

#include <RcppArmadillo.h>
// [[Rcpp::depends(RcppArmadillo)]]
using namespace Rcpp;

// [[Rcpp::export]]
arma::vec equalizeC(const arma::vec& y, const arma::vec& rng, int levels) {
  arma::vec breaks = arma::linspace(rng[0], rng[1], levels + 1);
  arma::uvec bins(y.n_elem);
  arma::vec equalized(y.n_elem);
  arma::uvec h = arma::histc(y, breaks);
  arma::vec cdf = arma::cumsum(arma::conv_to<arma::vec>::from(h));
  int cdf_min = arma::min(cdf.elem(arma::find(cdf > 0)));
  int n = y.n_elem;
  
  for (unsigned int k = 0; k < y.n_elem; k++) {
    equalized[k] = (cdf[k] - cdf_min) / (n - cdf_min) * (rng[1] - rng[0]);
    bins[k] = std::round((y[k] - rng[0]) / (rng[1] - rng[0]) * (levels-1)) + 1;
  }
  
  return equalized.elem(bins);
}
