#ifndef __CONV_CONF_HEADER_
#define __CONV_CONF_HEADER_

#define LARGE_DATA_SET	0
#define MEDIUM_DATA_SET	0
#define SMALL_DATA_SET	1

#if LARGE_DATA_SET
	#define BATCH_SIZE 100
#elif MEDIUM_DATA_SET
	#define BATCH_SIZE 32
#elif SMALL_DATA_SET
	#define BATCH_SIZE 8
#endif

// Size of one data dimension

#if LARGE_DATA_SET
	#define FEATURE_SIZE 152
#elif MEDIUM_DATA_SET
	#define FEATURE_SIZE 64
#elif SMALL_DATA_SET
	#define FEATURE_SIZE 32
#endif

// Number of layers
#define NUM_LAYERS 4
// Sequence length
#define SEQ_LENGTH 100

// If this is defined, print 10 array elements only
#define PRINT_ONLY_10 100

#define NB_TESTS 1

#ifdef __cplusplus
double median(std::vector<std::chrono::duration<double, std::milli>> scores)
{
    double median;
    size_t size = scores.size();

    sort(scores.begin(), scores.end());

    if (size % 2 == 0)
    {
        median = (scores[size / 2 - 1].count() + scores[size / 2].count()) / 2;
    }
    else
    {
        median = scores[size / 2].count();
    }

    return median;
}
#else
double median(int n, double x[])
{
    double temp;
    int i, j;

    // the following two loops sort the array x in ascending order
    for(i=0; i<n-1; i++) {
        for(j=i+1; j<n; j++) {
            if(x[j] < x[i]) {
                // swap elements
                temp = x[i];
                x[i] = x[j];
                x[j] = temp;
            }
        }
    }

    if(n%2==0) {
        // if there is an even number of elements, return mean of the two elements in the middle
        return((x[n/2] + x[n/2 - 1]) / 2.0);
    } else {
        // else return the element in the middle
        return x[n/2];
    }
}
#endif

#endif
