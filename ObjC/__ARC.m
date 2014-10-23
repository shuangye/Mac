Pro Multithreading and Memory Management for iOS and OS X

Chapter 1 - Life Before ARC
规则：
*) You have ownership of any objects you create. +alloc/+new/-copy/-mutableCopy group
*) You can take ownership of an object using retain. -retain
*) When no longer needed, you must relinquish ownership of an object you own. -release
*) You must not relinquish ownership of an object you don't own, or the app will crash.
若在方法内创建了对象，则该方法拥有该对象的所有权；若该方法把它拥有所有权的对象返回给调用者，则所有权就传递给了调用者。按照惯例，该方法名应以 alloc 开头。
方法也可以返回没有所有权的对象，这样的方法不能以 alloc/new/copy/mutableCopy 开头。实现方式一般是在返回之前对其调用 autorelease 方法，NSMutableArray 的 array 方法就是这样实现的。
Create and have ownership of it: +alloc/+new/-copy/-mutableCopy group
Take ownership of it: -retain
Relinquish it: -release
Dispose of it: -dealloc
-copy 方法创建一个对象的副本，该类必须实现 <NSCopying> 协议并实现 copyWithZone: 方法。-mutableCopy 创建一个 mutable 副本，该类必须实现 <NSMutableCopying> 协议并实现 mutableCopyWithZone: 方法。
这些方法不是由 Objective-C 语言本身提供的，而是 Foundation Framework 提供的。+alloc 是 NSObject 的一个类方法，-retain, -release, -dealloc 是其实例方法。
id obj = [[NSObject alloc] init];
id obj = [NSobject new];  // same as above

Simplified Implementation
GNUstep
struct obj_layout {
    NSUInteger retained;  // to store reference count
};
+ (id) alloc
{
    // a header + the object itself.
    int size = sizeof(struct obj_layout) + SIZE_OF_THE_OBJECT;
    struct obj_layout *p = (struct obj_layout *)calloc(1, size);
    return (id)(p + 1);  // return the actual object
}

// get the reference count
- (NSUInteger) retainCount
{
    return NSExtraRefCount(self) + 1;
}
inline NSUInteger NSExtraRefCount(id anObject)
{
    return ((struct obj_layout *)anObject)[-1].retained;
}

- (id)retain
{
    ++((struct obj_layout *)self)[-1].retained;
    return self;
}