//
//  MainTabBarViewController.m
//  Score Log
//
//  Created by Sébastien Brugalières on 17/03/2018.
//

#import "MainTabBarViewController.h"

@interface MainTabBarViewController ()

@end

@implementation MainTabBarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.delegate = self;
    
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

-(BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController {
    if (self.selectedViewController == nil || viewController == self.selectedViewController) {
        return FALSE;
    }
    
    UIView* fromView = self.selectedViewController.view;
    UIView* toView = viewController.view;
    
    [UIView transitionFromView:fromView toView:toView duration:0.3 options:UIViewAnimationOptionTransitionCrossDissolve completion:Nil];
    
    return true;
}

@end
