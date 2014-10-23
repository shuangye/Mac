Pro Multithreading and Memory Management for iOS and OS X

Chapter 1 - Life Before ARC
����
*) You have ownership of any objects you create. +alloc/+new/-copy/-mutableCopy group
*) You can take ownership of an object using retain. -retain
*) When no longer needed, you must relinquish ownership of an object you own. -release
*) You must not relinquish ownership of an object you don't own, or the app will crash.
���ڷ����ڴ����˶�����÷���ӵ�иö��������Ȩ�����÷�������ӵ������Ȩ�Ķ��󷵻ظ������ߣ�������Ȩ�ʹ��ݸ��˵����ߡ����չ������÷�����Ӧ�� alloc ��ͷ��
����Ҳ���Է���û������Ȩ�Ķ��������ķ��������� alloc/new/copy/mutableCopy ��ͷ��ʵ�ַ�ʽһ�����ڷ���֮ǰ������� autorelease ������NSMutableArray �� array ������������ʵ�ֵġ�
Create and have ownership of it: +alloc/+new/-copy/-mutableCopy group
Take ownership of it: -retain
Relinquish it: -release
Dispose of it: -dealloc
-copy ��������һ������ĸ������������ʵ�� <NSCopying> Э�鲢ʵ�� copyWithZone: ������-mutableCopy ����һ�� mutable �������������ʵ�� <NSMutableCopying> Э�鲢ʵ�� mutableCopyWithZone: ������
��Щ���������� Objective-C ���Ա����ṩ�ģ����� Foundation Framework �ṩ�ġ�+alloc �� NSObject ��һ���෽����-retain, -release, -dealloc ����ʵ��������
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