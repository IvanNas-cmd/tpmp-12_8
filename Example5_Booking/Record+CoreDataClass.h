#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
@interface Record : NSManagedObject
@property (nonatomic, retain) NSString *cityFrom;
@property (nonatomic, retain) NSString *cityTo;
@property (nonatomic, retain) NSString *aviaCompany;
@property (nonatomic, retain) NSNumber *price;
@end