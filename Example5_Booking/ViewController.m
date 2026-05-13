#import "ViewController.h"
#import <CoreLocation/CoreLocation.h>
@interface ViewController () { int isCity; MKPointAnnotation *annotationFrom; MKPointAnnotation *annotationTo; }
@end
@implementation ViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    UILongPressGestureRecognizer *lp = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleLongPress:)];
    [self.map addGestureRecognizer:lp];
}
- (void)handleLongPress:(UIGestureRecognizer *)sender {
    if (sender.state == UIGestureRecognizerStateEnded) {
        CGPoint point = [sender locationInView:self.map];
        CLLocationCoordinate2D coord = [self.map convertPoint:point toCoordinateFromView:self.map];
        CLLocation *loc = [[CLLocation alloc] initWithLatitude:coord.latitude longitude:coord.longitude];
        CLGeocoder *geocoder = [[CLGeocoder alloc] init];
        [geocoder reverseGeocodeLocation:loc completionHandler:^(NSArray *placemarks, NSError *error) {
            for (CLPlacemark *pm in placemarks) {
                [self setAnnotation:self->isCity :pm.locality :coord];
            }
        }];
    }
}
- (void)setAnnotation:(int)type :(NSString *)title :(CLLocationCoordinate2D)coord {
    if (type == 0) {
        [self.map removeAnnotation:annotationFrom];
        annotationFrom = [[MKPointAnnotation alloc] init];
        annotationFrom.title = title;
        annotationFrom.coordinate = coord;
        [self.map addAnnotation:annotationFrom];
        self.cityFrom.text = title;
    }
}
- (void)textFieldDidBeginEditing:(UITextField *)tf {
    if (tf == self.cityFrom) isCity = 0;
    else if (tf == self.cityTo) isCity = 1;
    [tf resignFirstResponder];
}
- (IBAction)showFlights:(id)sender {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Flights" message:@"From: \(self.cityFrom.text) To: \(self.cityTo.text)" preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil]];
    [self presentViewController:alert animated:YES completion:nil];
}
@end