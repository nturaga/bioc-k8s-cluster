# RedisParam demo

## Terminal 1 - First start the redis server

	redis-server

## Talk about Manager + worker paradigm

## Manager terminal 1 - start R

Manager process

	library(RedisParam)

	p <- RedisParam(jobname = 'new', is.worker = FALSE)

	print(p) ## Notice there are no workers

	bpstart(p) ## notice there are still no workers

## Create some Redis Workers

### Terminal 2 - start R

	library(RedisParam)

	wp <- RedisParam(jobname = 'new', is.worker = TRUE) ## worker process

	bpstart(wp)

### Terminal 3 - start R

	library(RedisParam)
	
	wp <- RedisParam(jobname = 'new', is.worker = TRUE) ## worker process
	
	bpstart(wp)

## Back to Manager terminal

	print(p) ## Notice that the 2 new workers are now recognized

## Do some work

	foo <- function(i) {
		Sys.sleep(1)
		Sys.getpid()
	}

	bplapply(1:4, foo, BPPARAM=p) ## BiocParallel like work


	bpstopall(p)
