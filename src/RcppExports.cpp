// Generated by using Rcpp::compileAttributes() -> do not edit by hand
// Generator token: 10BE3573-1514-4C36-9D1C-5A225CD40393

#include <RcppArmadillo.h>
#include <Rcpp.h>

using namespace Rcpp;

#ifdef RCPP_USE_GLOBAL_ROSTREAM
Rcpp::Rostream<true>&  Rcpp::Rcout = Rcpp::Rcpp_cout_get();
Rcpp::Rostream<false>& Rcpp::Rcerr = Rcpp::Rcpp_cerr_get();
#endif

// mandelRcpp
arma::mat mandelRcpp(const double x_min, const double x_max, const double y_min, const double y_max, const int res_x, const int res_y, const int nb_iter);
RcppExport SEXP _mandelExplorer_mandelRcpp(SEXP x_minSEXP, SEXP x_maxSEXP, SEXP y_minSEXP, SEXP y_maxSEXP, SEXP res_xSEXP, SEXP res_ySEXP, SEXP nb_iterSEXP) {
BEGIN_RCPP
    Rcpp::RObject rcpp_result_gen;
    Rcpp::RNGScope rcpp_rngScope_gen;
    Rcpp::traits::input_parameter< const double >::type x_min(x_minSEXP);
    Rcpp::traits::input_parameter< const double >::type x_max(x_maxSEXP);
    Rcpp::traits::input_parameter< const double >::type y_min(y_minSEXP);
    Rcpp::traits::input_parameter< const double >::type y_max(y_maxSEXP);
    Rcpp::traits::input_parameter< const int >::type res_x(res_xSEXP);
    Rcpp::traits::input_parameter< const int >::type res_y(res_ySEXP);
    Rcpp::traits::input_parameter< const int >::type nb_iter(nb_iterSEXP);
    rcpp_result_gen = Rcpp::wrap(mandelRcpp(x_min, x_max, y_min, y_max, res_x, res_y, nb_iter));
    return rcpp_result_gen;
END_RCPP
}
// mandelRcpp2
IntegerVector mandelRcpp2(double x_min, double x_max, double y_min, double y_max, int res_x, int res_y, int nb_iter);
RcppExport SEXP _mandelExplorer_mandelRcpp2(SEXP x_minSEXP, SEXP x_maxSEXP, SEXP y_minSEXP, SEXP y_maxSEXP, SEXP res_xSEXP, SEXP res_ySEXP, SEXP nb_iterSEXP) {
BEGIN_RCPP
    Rcpp::RObject rcpp_result_gen;
    Rcpp::RNGScope rcpp_rngScope_gen;
    Rcpp::traits::input_parameter< double >::type x_min(x_minSEXP);
    Rcpp::traits::input_parameter< double >::type x_max(x_maxSEXP);
    Rcpp::traits::input_parameter< double >::type y_min(y_minSEXP);
    Rcpp::traits::input_parameter< double >::type y_max(y_maxSEXP);
    Rcpp::traits::input_parameter< int >::type res_x(res_xSEXP);
    Rcpp::traits::input_parameter< int >::type res_y(res_ySEXP);
    Rcpp::traits::input_parameter< int >::type nb_iter(nb_iterSEXP);
    rcpp_result_gen = Rcpp::wrap(mandelRcpp2(x_min, x_max, y_min, y_max, res_x, res_y, nb_iter));
    return rcpp_result_gen;
END_RCPP
}
// mandelsmoothRcpp
arma::mat mandelsmoothRcpp(const double x_min, const double x_max, const double y_min, const double y_max, const int res_x, const int res_y, const int nb_iter);
RcppExport SEXP _mandelExplorer_mandelsmoothRcpp(SEXP x_minSEXP, SEXP x_maxSEXP, SEXP y_minSEXP, SEXP y_maxSEXP, SEXP res_xSEXP, SEXP res_ySEXP, SEXP nb_iterSEXP) {
BEGIN_RCPP
    Rcpp::RObject rcpp_result_gen;
    Rcpp::RNGScope rcpp_rngScope_gen;
    Rcpp::traits::input_parameter< const double >::type x_min(x_minSEXP);
    Rcpp::traits::input_parameter< const double >::type x_max(x_maxSEXP);
    Rcpp::traits::input_parameter< const double >::type y_min(y_minSEXP);
    Rcpp::traits::input_parameter< const double >::type y_max(y_maxSEXP);
    Rcpp::traits::input_parameter< const int >::type res_x(res_xSEXP);
    Rcpp::traits::input_parameter< const int >::type res_y(res_ySEXP);
    Rcpp::traits::input_parameter< const int >::type nb_iter(nb_iterSEXP);
    rcpp_result_gen = Rcpp::wrap(mandelsmoothRcpp(x_min, x_max, y_min, y_max, res_x, res_y, nb_iter));
    return rcpp_result_gen;
END_RCPP
}

static const R_CallMethodDef CallEntries[] = {
    {"_mandelExplorer_mandelRcpp", (DL_FUNC) &_mandelExplorer_mandelRcpp, 7},
    {"_mandelExplorer_mandelRcpp2", (DL_FUNC) &_mandelExplorer_mandelRcpp2, 7},
    {"_mandelExplorer_mandelsmoothRcpp", (DL_FUNC) &_mandelExplorer_mandelsmoothRcpp, 7},
    {NULL, NULL, 0}
};

RcppExport void R_init_mandelExplorer(DllInfo *dll) {
    R_registerRoutines(dll, NULL, CallEntries, NULL, NULL);
    R_useDynamicSymbols(dll, FALSE);
}
