JASwipeCell
===========

##Overview

iOS 8 Mail Inspired. A UITableViewCell subclass that displays customizable left or right buttons that are revealed as the user swipes the cell in either direction. The edge-most buttons will pin to the container view and will execute an event similar to how the delete/archive button work in IOS 8 mail.

##Features
* Supports adding actionable buttons on either side of the cell. 
* You can customize a button's title text and color.
* Each button will have a block handler that will execute when pressed.
* The left/right most button will pin to the top container view as the user swipes all the way. This will also execute that button's action. 

Example of the buttons revealing as you swipe left:

![image](http://i.imgur.com/mtGJx2f.png)

Example of the right most button pinning to the container view:

![image](http://i.imgur.com/T3v3nWB.png)

##Usage

###Set up the cell

First step is to subclass `JASwipeCell.h`. You have full control of the views rendered on this cell and they must be added as subviews to JASwipeCell's topContainerView. You can use a xib file or do this in code. The example provided is done in code using [PureLayout](https://github.com/smileyborg/PureLayout).


###Set up the buttons 

Next step is to set up the left/right buttons. I've created a `JAActionButton` class that has a class method to quickly create a button with a title, background color, and completion handler. 

```objc
- (NSArray *)leftButtons
{
    __typeof(self) __weak weakSelf = self;
    JAActionButton *button1 = [JAActionButton actionButtonWithTitle:@"Delete" color:[UIColor redColor] handler:^(UIButton *actionButton, JASwipeCell*cell) {
        [cell completePinToTopViewAnimation];
        [weakSelf leftMostButtonSwipeCompleted:cell];
    }];
    
    JAActionButton *button2 = [JAActionButton actionButtonWithTitle:@"Mark as unread" color:kUnreadButtonColor handler:^(UIButton *actionButton, JASwipeCell*cell) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Mark As Unread" message:@"Done!" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        [alert show];
    }];
    
    return @[button1, button2];
}

- (NSArray *)rightButtons
{
    __typeof(self) __weak weakSelf = self;
    JAActionButton *button1 = [JAActionButton actionButtonWithTitle:@"Archive" color:kArchiveButtonColor handler:^(UIButton *actionButton, JASwipeCell*cell) {
        [cell completePinToTopViewAnimation];
        [weakSelf rightMostButtonSwipeCompleted:cell];
    }];
    
    JAActionButton *button2 = [JAActionButton actionButtonWithTitle:@"Flag" color:kFlagButtonColor handler:^(UIButton *actionButton, JASwipeCell*cell) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Flag" message:@"Flag pressed!" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        [alert show];
    }];
    JAActionButton *button3 = [JAActionButton actionButtonWithTitle:@"More" color:kMoreButtonColor handler:^(UIButton *actionButton, JASwipeCell*cell) {
        UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:@"More Options" delegate:nil cancelButtonTitle:@"Cancel" destructiveButtonTitle:@"Option 1" otherButtonTitles:@"Option 2",nil];
        [sheet showInView:weakSelf.view];
    }];
    
    return @[button1, button2, button3];
}
```

###Set up the table view. 

Now you must create your cell instances using the button creation methods above.

```objc
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    JATableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kJATableViewCellReuseIdentifier];
    
    [cell addActionButtons:[self leftButtons] withButtonWidth:kJAButtonWidth withButtonPosition:JAButtonLocationLeft];
    [cell addActionButtons:[self rightButtons] withButtonWidth:kJAButtonWidth withButtonPosition:JAButtonLocationRight];
    
    cell.delegate = self;
    
    [cell configureCellWithTitle:self.tableData[indexPath.row]];
    [cell setNeedsLayout];
    [cell setNeedsUpdateConstraints];
    [cell updateConstraintsIfNeeded];
    
    return cell;
}
```

###Respond to delegate methods.

There are a list of delegate methods available that get called as swipe events occur on the cell.

```objc
@protocol JASwipeCellDelegate <NSObject>
- (void)leftMostButtonSwipeCompleted:(JASwipeCell *)cell;
- (void)rightMostButtonSwipeCompleted:(JASwipeCell *)cell;
@optional
- (void)swipingRightForCell:(JASwipeCell *)cell;
- (void)swipingLeftForCell:(JASwipeCell *)cell;
@end
```

In the project example, swiping a cell all the way to the left will trigger the "Archive" button to execute. This will call the delegate method `rightMostButtonSwipeCompleted:`, which is responsible for updating the table's data and deleting the row. 

```objc
- (void)rightMostButtonSwipeCompleted:(JASwipeCell *)cell
{
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    [self.tableData removeObjectAtIndex:indexPath.row];
    
    [self.tableView beginUpdates];
    [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    [self.tableView endUpdates];
}
```

##Example Project
An example project is provided. It requires IOS7 and can be run on device or simulator. This will work for any device size. 

##Creator
Jose Alvarez

##License
JASwipeCell is available under the MIT license. See the LICENSE file for more info.
