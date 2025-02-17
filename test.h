/* @OMIT
 * This is an obnoctious copyright notice, clearly written by a blind man.
 */
#ifndef TEST_H
#define TEST_H
// # Test
// ## Functions
/* This comment describes the functions below,
 *  in long form.
 */
void foo(void);
void bar(void);

// This function is exceptional somehow.
void fizzbuzz(int i);



// This is some real strange newlininging.


void wicked(const char * const str, const size_t n);

// ## Structures
/* The byte structure is utterly useless.
 * It has zero purpose.
 * Clearly, it should not be here for multiple reasons:
 * * more lines of code to maintain
 * * bloats up your namespace
 */
struct byte { unsigned char b; };

// ## Attempting to make this longer
/* One day a student came to Moon and said:
 * 
 * "I understand how to make a better garbage collector.
 * We must keep a reference count of the pointers to each cons."
 * 
 * Moon patiently told the student the following story:
 * 
 * "One day a student came to Moon and said:
 * ‘I understand how to make a better garbage collector...
 * 
 * [Ed. note:
 * Pure reference-count garbage collectors have problems
 * with circular structures that point to themselves.
 * ]
*/

// @OMIT
#endif
