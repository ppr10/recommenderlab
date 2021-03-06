## recommend random unknown items

RANDOM <- function(data=NULL, parameter=NULL) {

  model <- list(range = range(as(data, "dgCMatrix")), labels = colnames(data))

  predict <- function(model=NULL, newdata, n=10,
    data= NULL, type=c("topNList", "ratings", "ratingMatrix"), ...) {

    type <- match.arg(type)

    ## newdata are userid
    if(is.numeric(newdata)) {
      if(is.null(data) || !is(data, "ratingMatrix"))
        stop("If newdata is a user id then data needes to be the training dataset.")
      newdata <- data[newdata, , drop = FALSE]
    }

    ## create random ratings
    ratings <- matrix(runif(nrow(newdata)*ncol(newdata),
      model$range[1], model$range[2]),
      nrow=nrow(newdata), ncol=ncol(newdata),
      dimnames=list(NULL, model$labels))

    returnRatings(ratings, newdata, type, n)
  }

  ## this recommender has no model
  new("Recommender", method = "RANDOM", dataType = "ratingMatrix",
    ntrain = nrow(data),
    model = model, predict = predict)
}

## register recommender
recommenderRegistry$set_entry(method="RANDOM", dataType="realRatingMatrix",
  fun=RANDOM,
  description="Produce random recommendations (real ratings).")

recommenderRegistry$set_entry(method="RANDOM", dataType="binaryRatingMatrix",
  fun=RANDOM,
  description="Produce random recommendations (binary ratings).")

