Objective C Class
=================

The [NSObject protocol](https://developer.apple.com/library/mac/documentation/cocoa/Reference/Foundation/Classes/NSObject_Class/Reference/Reference.html) groups methods that are fundamental to all Objective-C objects, features including: class type, responding message, retain and release.

Objective C Memory Management
=============================

[Advanced Memory Management Programming Guide](https://developer.apple.com/library/mac/documentation/Cocoa/Conceptual/MemoryMgmt/Articles/MemoryMgmt.html)

###Two methods of application memory management

1. MRR, manual retain-release
2. ARC, automatic reference counting

###Two problems

1. Freeing data in use
2. Not freeing data that is no longer in use

###MRR, manual retain-release

1. Two ways to create an object:
  * “alloc”, “new”, “copy”, or “mutableCopy”, own this object.
  * Other method, autorelease
2. Take ownership of an object by retain.
3. Relinquish ownership, by release, autorelease(stay valid until at least the end of the scope that it was called in), send dealloc message if counts equals to zero.
4. retain, release and autorelease are defined in the NSObject Protocol.

###ARC, automatic reference counting

[Transitioning to ARC Release Notes](https://developer.apple.com/library/mac/releasenotes/ObjectiveC/RN-TransitioningToARC/Introduction/Introduction.html)

* Four qualifiers for object pointers, the two important are strong and weak. Strong reference will retain object, week will not. When strong get out of scope, release will be called. Strong property is the same, but when this object is deallocated, release will be called.

* Autoreleasing is used for multiple returns by pointers. It likes the strong pointer, but will hold the result after the function return.

###Practical Tips

* Do not need to worry about class method like **[NSString stringWithFormat:]**, because they are using autorelease to return an object.

* Dealloc is never called manually. Only called by **[Super dealloc]**.

* For Property, you must declare the ownership of it, either by alloc it or retain it.

* Use set accessor as many as possible.

* Do not use accessor methods in initializer and dealloc

  * B extends A, but if accessor is used in A, it could be override in B, which means that the methods of B is called before B is initialized. The same for dealloc, method of B will be called after B disappeared.

* Use week reference to avoid memory cycle. The reference is week unless using retain.

* Be carefully when releasing the parent or collection of an object.

* Collections automatically call retain and release.

###Autorelease Pool Blocks

* release called when get out of this block.

* AppKit and UIKit frameworks process each event-loop iteration within an autorelease pool block.

* Could add custom autorelease pool block

Constructor
===========

Constructor should not be override, since it should be the duty of this class to construct its objects, not the sub-classes' duty.

###Objective C

**[[Class alloc] init]** alloc some memory on the heap and init it, two problems:

1. A sub-class always need to call the constructor of the super-class. Easy to forget.
2. Always return an instance of this class. Repeat it everywhere. Could use **instancetype**.

###Java

1. Give a default, no-parameter constructor to every class, sub-class automatically call default super constructor. But if you define a custom constructor, the default one will be removed, and sub-class need to call **super(...)**.
2. No return for constructors in Java.

Static Binding or Dynamic Binding
=================================

* Static binding => compile time
* Dynamic binding => runtime

Unicode
=======

Using 2 bytes to store one character, this is called **code point**. We usually use 4 hexadecimal number to represent it, U+xxxx. UTF-8 is one way to encoding Unicode into bits, code point from 0-127 is stored in single byte.

Bitwise Operation
=================

###XOR

1. a^1 = flip a
2. a^0 = a
3. a^a = 0

###Negative number

* flip and +1
  * 00 ->  0
  * 01 ->  1
  * 10 -> -2
  * 11 -> -1

* 10 ... 0, is the smallest number
* & bitwise and, && logical and return true or false
* the same for | and ||
* ~ flips every bits
* \>\>> repeat the sign in front, negative number divided by 2
* \>> do not repeat the sign in front
* Bitwise operations have priority.

LeetCode Round 2
================

###02/12/2014

* Valid Palindrome
* Remove Nth Node From End of List
* Unique Binary Search Trees II
* Combinations
