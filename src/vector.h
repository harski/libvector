#ifndef VECTOR_H
#define VECTOR_H

#include <stddef.h>

#define VECTOR_DEFAULT_SIZE 8

typedef struct vector Vector;
struct vector {
    size_t size;
    unsigned int elements;
    void **list;
};


int vector_add (struct vector *v, void *element);
struct vector * vector_create ();
struct vector * vector_create_size (size_t size);
void vector_destroy (struct vector *v);
void * vector_get (struct vector *v, unsigned int index);
void * vector_remove (struct vector *v, unsigned int index);


#endif /* VECTOR_H */

