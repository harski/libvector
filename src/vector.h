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


int vector_add (struct vector *v, void *element);
int vector_add_vector (struct vector *v1, struct vector *v2);
struct vector * vector_init ();
struct vector * vector_init_size (size_t size);
struct vector * vector_create ();
struct vector * vector_create_size (size_t size);
void vector_destroy (struct vector *v);
void * vector_get (const struct vector *v, unsigned int index);
void * vector_remove (struct vector *v, unsigned int index);
void vector_compact (struct vector *v);

#endif /* VECTOR_H */

