iOS and Objective C
===================

###UIViewController initialization
1. **initWithNibName:bundle:** is called to initialize a view controller, the nib name and the place to find it is passed. In custom init function, **[super initWithNibName:bundle:]** should be called.
2. When the controller needs to display, it tries to display the root view, if it is null, **loadView** will be called.
3. If **loadView** is not override, it tries to find the nib file and use it to init root view. If it is override, it means we want to create view programmatically, the root view need to be assigned with a view.
4. **viewDidLoad** do some additional init, especially for nib.
5. **viewWillAppear**, going back and forth between views.
6, **viewDidAppear**.

###Blocks
* Allow access to local variables, use week to avoid memory cycle.
* \_\_block is used to change variable outside this block.

###Threading and concurrency
* The term thread is used to refer to a separate path of execution for code.
* The term process is used to refer to a running executable, which can encompass multiple threads.
* The term task is used to refer to the abstract concept of work that needs to be performed.
* Each thread has its own execution stack and is scheduled for runtime separately by the kernel.
* All threads in a single application share the same virtual memory space and have the same access rights as the process itself.

###Dynamic Binding
* When a new object is created
  * Memory for it is allocated and erased to 0.
  * Its instance variables are initialized.
  * Point to a class structure by isa.
  * Class structure has a pointer point to the superclass.
  * Receiving object => self, and own selector => \_cmd

###Selector
* Implement an object that uses the target-action design pattern. Target is an object, action is the method called on the object. In java, we use interface to do it.
* SEL is the type of selector.

###NSInvocation
* If you send a message to an object that does not handle that message, before announcing an error the runtime sends the object a forwardInvocation: message with an NSInvocation object as its sole argument—the NSInvocation object encapsulates the original message and the arguments that were passed with it.
* Result returned to the original sender.
* Muti-inheritance, proxy.

###Protocol
* Optional
* Inheritance
* id\<protocol\>

###Types
* These types, like NSInteger and NSUInteger, are defined differently depending on the target architecture(32, 64).

###Notification
* Keep a list in the notification center. When sending a request, call the correspond object in the list.
* It can also be implemented by target-action, but in order to use target-action, all object need to hold the delegate, if there are mutiple delegate, and they are not belongs to this object, it is not good to save the instance in it.

###library
* Cocoa is the API for OS X.
* Cocoa Touch is the API for iOS.
* Including foundation kit, application kit, and core data frameworks.
  * Foundation Kit: basic classes.
  * Application Kit: graphical, event-driven user interface: windows, panels, buttons, menus, scrollers, and text fields.
  * Core data: database.

###Objective C Class
* A root class inherits from no other class, you can define custom root classes.
* The [NSObject protocol](https://developer.apple.com/library/mac/documentation/cocoa/Reference/Foundation/Classes/NSObject_Class/Reference/Reference.html) groups methods that are fundamental to all Objective-C objects, features including: class type, responding message, retain and release, alloc.
* In Objective-C, a class is itself an object with an opaque type called Class.
* The class of an object is determined at runtime, it makes no difference what type you assign a variable when creating or working with an instance.
* BOOL: NO, YES.
* id is automatically initialized with nil.
* Define instance variables in interface block
      //Objective C
      @interface SomeClass : UIViewController <UITextFieldDelegate> {
          UITextField *_textField;
          BOOL _someBool;
      }

###Property
* The compiler will automatically synthesize an instance variable in all situations where it’s also synthesizing at least one accessor method. 
* If you implement both a getter and a setter for a readwrite property, or a getter for a readonly property, the compiler will assume that you are taking control over the property implementation and won’t synthesize an instance variable automatically.
* If you still need an instance variable, you’ll need to request that one be synthesized: @synthesize property = \_property.
* The internal implementation and synchronization of atomic accessor methods is private, cannot override it.
* atomic is not thread safety, two threads read and write at the same time is OK, but the order is undetermined.
* Cache the week pointer in multi-threaded application. Assign a local strong pointer to it. Which means, save the weak pointer in a local pointer (strong), to make sure that it will not be released in this function.

###Category
* Declared in a separate header file and implemented in a separate source code file.
* Can add class method and instance method, but it is not good to add property, since no local variables can be added by category.
* Method cannot have same name with other categories or super class. Which one to call is undefined. Add prefix to category methods. Since this is not inheritance, there is no inheritance structure.
* Class extension is "ClassName ()" anonymous category. Only have one and instance variables can be added.

###Static
* Static method is send to Class, class is defined in NSObject protocol.

###Objective C Memory Management, [Advanced Memory Management Programming Guide](https://developer.apple.com/library/mac/documentation/Cocoa/Conceptual/MemoryMgmt/Articles/MemoryMgmt.html)

####Two methods of application memory management
1. MRR, manual retain-release
2. ARC, automatic reference counting

####Two problems
1. Freeing data in use
2. Not freeing data that is no longer in use

####MRR, manual retain-release
1. Two ways to create an object:
  * “alloc”, “new”, “copy”, or “mutableCopy”, own this object.
  * Other method, autorelease.
2. Take ownership of an object by retain.
3. Relinquish ownership, by release, autorelease(stay valid until at least the end of the scope that it was called in), send dealloc message if counts equals to zero.
4. retain, release and autorelease are defined in the NSObject Protocol.

####ARC, automatic reference counting, [Transitioning to ARC Release Notes](https://developer.apple.com/library/mac/releasenotes/ObjectiveC/RN-TransitioningToARC/Introduction/Introduction.html)
1. Four qualifiers for object pointers, the two important are strong and weak. Strong reference will retain object, week will not. When strong get out of scope, release will be called. Strong property is the same, but when this object is deallocated, release will be called.
3. unsafe\_unretained is like week but will not set to nil, when no strong pointer.
2. Autoreleasing is used for multiple returns by pointers. It likes the strong pointer, but will hold the result after the function return.
        NSError * error = nil;
        [ database save: &error ];

        NSError * __strong error = nil;
        NSError * __autoreleasing tmpError = error;
        [ database save: &tmpError ]; // count 1
        error = tmpError; // count 2
        // auto release, count 1

####Practical Tips
1. Do not need to worry about class method like **[NSString stringWithFormat:]**, because they are using autorelease to return an object.
2. Dealloc is never called manually. Only called by **[Super dealloc]**.
3. For Property, you must declare the ownership of it, either by alloc it or retain it.
4. Use set accessor as many as possible, since retain and release need to called on the new and old value.
5. Do not use accessor methods in initializer and dealloc: 
   B extends A, but if accessor is used in A, it could be override in B, which means that the methods of B is called before B is initialized. The same for dealloc, method of B will be called after B disappeared.
6. Use week reference to avoid memory cycle. The reference is week unless using retain.
7. Be carefully when releasing the parent or collection of an object, since if weak pointers hold it, it will disappear.
8. Collections automatically call retain and release.

####Autorelease Pool Blocks
1. Release called when get out of this block.
2. AppKit and UIKit frameworks process each event-loop iteration within an autorelease pool block.
3. Could add custom autorelease pool block

###Constructor
* Constructor should not be override, since it should be the duty of this class to construct its objects, not the sub-classes' duty.
* **malloc** clean memory to zero.
* **new** is the same as **[ alloc] init]**
* **[[Class alloc] init]** alloc some memory on the heap and init it, two problems:
  * A sub-class always need to call the constructor of the super-class. Easy to forget.
  * Always return an instance of this class. Repeat it everywhere. Could use **instancetype**.
* **self = [super init];** super is the same to self, but calling the function from the super class, the return value is almost always self, it is just an tradition to assign it to self. The rare cases, the return value is not self.

Stack frame
===========
* The size of each stack frame is dynamically determined when compile.
* The value in ebp is the old ebp, set some offset to get the arguments and local variables.
* eip is ebp-4.
* esp is move to the top of the current frame and the content is cleaned up.
* Registers are push to stack staring at esp
* When return esp first move to ebp, ebp set to old ebp and eip is pop.

Java
====

1. Give a default, no-parameter constructor to every class, sub-class automatically call default super constructor. But if you define a custom constructor, the default one will be removed, and sub-class need to call **super(...)**.
2. No return for constructors in Java.
3. Iterator need to keep an attribute points to the next element. Check whether it is none for hasNext(), and return it for next().3. Iterator need to keep an attribute points to the next element. Check whether it is none for hasNext(), and return it for next().3. Iterator need to keep an attribute points to the next element. Check whether it is none for hasNext(), and return it for next().

External Merge Sort
=============

* The memory is not large enough to hold all the elements, part of the data is read from the file and sort.
* Save results in another file.

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
1. a ^ 1 = flip a
2. a ^ 0 = a
3. a ^ a = 0

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

Trie vs Hash Table
==================

###Advantages
* In order to get the hash value, we need to go through the string, it is the same for trie. And there are collisions in hash table. If we do not use all the charactors to compute the hash value, there are more collisions.
* There is no need to provide a hash function or to change hash functions as more keys are added to a trie.
* A trie can provide an alphabetical ordering of the entries by key.

###Disadvantages
* Tries can be slower in some cases than hash tables for looking up data, especially if the data is directly accessed on a hard disk drive or some other secondary storage device where the random-access time is high compared to main memory.
* Some keys, such as floating point numbers, can lead to long chains and prefixes that are not particularly meaningful. Nevertheless a bitwise trie can handle standard ieee single and double format floating point numbers.
* Some tries can require more space than a hash table, as memory may be allocated for each character in the search string, rather than a single chunk of memory for the whole entry, as in most hash tables.

RESTful API
===========

###There is no standard rules
    A simple example:
            /teachers   /teachers/:id
    Get     index       show
    Post    create    
    Put                 update
    Delete  remove      destroy

###Rails
* There are 7 actions, two interesting pairs are new/create and edit/update, new and edit are just used to render a view for create and update. So the actual actions are 5. Compared with the example above, no remove.

* HTTP is a stateless protocol. Sessions make it stateful. The session saves the current status of a user and the session id is sent to the user. The user can use this id to login without authenticate again.

* For URL like /users/1/students, the server can save 1 to params[:user\_id] automatically.

HTTP Request
===========

###HTTPS
* Man In The Middle
  * DNS spoofing: insert the man in the middle.
  * Provide fake key to the server and client.
* Layering HTTP on a transport layer security protocol.
  * The public key from the server has certificate authority(CA).

###HTTP Structure
* HTTP header
  * request or respond line
  * MIME header
* HTTP request body
  * GET does not have body.
  * POST contains the data.

###port
* There are two ports, *source port* and *destination port*. When sending an http request, browser asks the OS for an available port as the *source port*, and the *destination port* is 80.
* When the server sends back the respond, the *destination port* is the browser port, the *source port* is 80.
Thus, there could be multiple browsers running and send the requests to the same server through the same port.

JQuery
======

It is a JavaScript library

Design pattern
==============

###proxy vs decorator
* proxy is used to represent the basic class.
* decorator is used to change the behavior dynamically.

C++
===

* Call stack variable will get it's destructor called when get out of scope.
* Smart pointer: scoped pointer, shared pointer(memory cycle, weak pointer).
* Call stack has fixed size, which is defined when compile.
* If you want to call a superclass constructor with an argument, you must use the subclass's constructor initialization list.
* Destructors are called automatically in the reverse order of construction. (Base classes last). Do not call base class destructors.
* Virtual function is dynamic binding. Other functions are static binding. One thing to be aware of is that if either transmitter or receiver attempted to invoke the storable constructor in their initialization lists, that call will be completely skipped when constructing a radio object.
* Pure virtual function makes the class it is defined for abstract, it is an abstract function.
* Virtual inheritance to solve the diamond problem. Create only one instance of the virtual based class. Virtual based class is constructed first and destroyed last.

Leetcode round 2
================

###02/12/2014
* valid palindrome
* remove nth node from end of list
* unique binary search trees ii
* Combinations

###02/18/2014
* Convert Sorted List to Binary Search Tree
  * stack and queue
* Minimum Depth of Binary Tree
  * BFS or DFS
* Maximum Depth of Binary Tree
  * BFS or DFS
* Rotate List
  * C++ modulus have negative result, (a%b+b)%b

###02/19/2014
* Jump Game II
  * Do not need to use DP.
* Jump Game

###02/20/2014
  * 3Sum

###02/21/2014
  * Binary Tree Level Order Traversal II
  * Longest Palindromic Substring
  * Sudoku Solver
  * Longest Valid Parentheses

###02/22/2014
  * Spiral Matrix
  * Regular Expression Matching
  * Sqrt(x)
    * Check int approximation
    * Newton's method

###02/23/2014
  * Palindrome Partitioning
  * Sort List
  * Reorder List
  * Longest Substring Without Repeating Characters
    * Map.Entry
  * Unique Paths
  * Unique Paths II
  * Minimum Path Sum
  * Triangle

###02/24/2014
  * Interleaving String

###03/05/2014
  * Word Ladder II
    * BFS + DFS
  * Max Points on a Line
  * Wildcard Matching
  * Edit Distance
  * Divide Two Integers
    * Over flow
  * Median of Two Sorted Arrays

###03/06/2014
  * Search in Rotated Sorted Array
  * Search in Rotated Sorted Array II
  * Evaluate Reverse Polish Notation 
  * Largest Rectangle in Histogram
  * Maximal Rectangle

###03/06/2014
  * Clone Graph

###03/08/2014
  * Merge Intervals
  * Merge Sorted Array
  * Merge k Sorted Lists
  * Best Time to Buy and Sell Stock
  * Best Time to Buy and Sell Stock II
  * Best Time to Buy and Sell Stock III
  * Word Search
  * Valid Palindrome
  * 4Sum

###03/09/2014
  * Word Break
  * Populating Next Right Pointers in Each Node
  * Populating Next Right Pointers in Each Node II
  * Path Sum
  * Path Sum II
