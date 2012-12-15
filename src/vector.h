/* Copyright 2011-2012 Tuomo Hartikainen <hartitu@gmail.com>.
 * Licensed under the 2-clause BSD license, see LICENSE. */


#ifndef VECTOR_H
#define VECTOR_H

#include <stddef.h>

#ifdef __GNUC__
#define DEPRECATED(func) func __attribute__ ((deprecated))
#elif defined(_MSC_VER)
#define DEPRECATED(func) __declspec(deprecated) func
#else
#pragma message("WARNING: You need to implement DEPRECATED for this compiler")
#define DEPRECATED(func) func
#endif

#define VECTOR_DEFAULT_SIZE 8

typedef struct vector Vector;
struct vector {
    size_t size;
    unsigned int elements;
    void **list;
};


/* Add element to vector v.
 * Returns the number of elements in vector v.*/
int vector_add (struct vector *v, void *element);

/* Add the elements in v2 to v1. v2 is left intact.
 * Returs the number of elements in v1.*/
int vector_add_vector (struct vector *v1, const struct vector *v2);

/* Initialize a vector with an initial capacity of VECTOR_DEFAULT_SIZE.
 * Returns the allocated, initialized vector, or if an error occured NULL. */
struct vector * vector_init ();

/* Initialize a vector with an initial capacity defined with size.
 * Returns the allocated, initialized vector, or if an error occured NULL.. */
struct vector * vector_init_size (size_t size);

/* Initialize a vector with an initial capacity of VECTOR_DEFAULT_SIZE.
 * Returns the allocated, initialized vector, or if an error occured NULL..
 * NOTE: THIS FUNCTION IS DEPRECATED. USE vector_init() INSTEAD. */
DEPRECATED(struct vector * vector_create ());

/* Initialize a vector with an initial capacity defined with size.
 * Returns the allocated, initialized vector, or if an error occured NULL..
 * NOTE: THIS FUNCTION IS DEPRECATED. USE vector_init_size() INSTEAD. */
DEPRECATED(struct vector * vector_create_size (size_t size));

/* Free vector v. v must be manually emptied first, this function doesn't
 * free the elements that might still be remaining in the vector. */
void vector_destroy (struct vector *v);

/* Get element specified by index from the vector v.
 * Returns the element in the index if such exists, otherwise NULL. */
void * vector_get (const struct vector *v, unsigned int index);

/* Get the last element in the vector v, or NULL if v is empty. */
void * vector_get_last (const struct vector *v);

/* Remove element from index specified by the "index" parameter from the vector
 * v and return it to the caller.
 * Returns the element at the index "index", or NULL if no such element
 * exists. */
void * vector_remove (struct vector *v, unsigned int index);

/* Remove the last element of the vector v and return it. If v is empty NULL
 * return NULL. */
void * vector_remove_last (struct vector *v);

/* Compacts the pointer array in vector v to be as small as possible. */
void vector_compact (struct vector *v);

#endif /* VECTOR_H */

