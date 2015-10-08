//
//  AddTextNoteViewController.m
//  云笔记
//
//  Created by 079 on 14-11-27.
//  Copyright (c) 2014年 wzc. All rights reserved.
//

#import "AddTextNoteViewController.h"

@interface AddTextNoteViewController () {
    UIDatePicker *datePicker;
    UITextField *subText;
    UITextField *dateText;
    UITextView *desText;
    UISegmentedControl *segment;
    NSInteger priority;
}

@end

@implementation AddTextNoteViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, 320, 568) style:UITableViewStyleGrouped];
    self.tableView.scrollEnabled = NO;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.allowsSelection = NO;
    self.tableView.userInteractionEnabled = YES;
    self.tableView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:self.tableView];
    
    datePicker = [[UIDatePicker alloc]initWithFrame:CGRectMake(0, 350, 320, 50)];
    [datePicker addTarget:self action:@selector(datePickerValueChanged) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:datePicker];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self action:@selector(save)];
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapOnTableView)];
    [self.tableView addGestureRecognizer:tapGesture];
    // Do any additional setup after loading the view from its nib.
}

- (void)viewWillAppear:(BOOL)animated {
    self.navigationController.toolbarHidden = YES;
}

- (void)viewDidAppear:(BOOL)animated {
    if (self.todo) {
        subText.text = self.todo.subject;
        segment.selectedSegmentIndex = self.todo._priority;
        dateText.text = self.todo._date;
        desText.text = self.todo.todoDescription;
    }
}

- (void)tapOnTableView {
    [subText resignFirstResponder];
    [desText resignFirstResponder];
}

- (void)datePickerValueChanged {
    NSDateFormatter *fm = [[NSDateFormatter alloc]init];
    [fm setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    dateText.text = [fm stringFromDate:datePicker.date];
}

- (void)segmentValueChanged {
    [subText resignFirstResponder];
    switch (segment.selectedSegmentIndex) {
        case 0:
            priority = 1;
            break;
        case 1:
            priority = 2;
            break;
        case 2:
            priority = 3;
            break;
            
        default:
            break;
    }
}

- (void)save {
    if (!self.todo) {
        self.todo = [[Todo alloc]initWithTodo:subText.text andtodoDescription:desText.text andpriority:priority anddate:dateText.text];
        [self.todoDB addToDo:self.todo];
        [self.todoDB write];
    }else {
        self.todo.subject = subText.text;
        self.todo.todoDescription = desText.text;
        self.todo._priority = priority;
        self.todo._date = dateText.text;
        [self.todoDB write];
    }
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)addDoneButton {
    UIToolbar *toolBar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, 320, 35)];
    UIBarButtonItem *flexibleSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
    UIBarButtonItem *doneItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(dismissKeyboard:)];
    toolBar.items = @[flexibleSpace, doneItem];
    desText.inputAccessoryView = toolBar;
}

- (void)dismissKeyboard:(id)sender {
    [desText resignFirstResponder];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 4;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *CellIdentifier = @"tableViewCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell) {
        //cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        switch (indexPath.row) {
            case 0:
                cell = [[[NSBundle mainBundle]loadNibNamed:@"subCell" owner:self options:nil]lastObject];
                subText = (UITextField *)[cell viewWithTag:100];
                subText.delegate = self;
                break;
            case 1:
                cell = [[[NSBundle mainBundle]loadNibNamed:@"priCell" owner:self options:nil]lastObject];
                segment = (UISegmentedControl *)[cell viewWithTag:101];
                [segment addTarget:self action:@selector(segmentValueChanged) forControlEvents:UIControlEventValueChanged];
                break;
            case 2:
                cell = [[[NSBundle mainBundle]loadNibNamed:@"dateCell" owner:self options:nil]lastObject];
                dateText = (UITextField *)[cell viewWithTag:102];
                [self datePickerValueChanged];
                [dateText setEnabled:NO];
                break;
            case 3:
            {
                cell = [[[NSBundle mainBundle]loadNibNamed:@"desCell" owner:self options:nil]lastObject];
                desText = (UITextView *)[cell viewWithTag:103];
                desText.layer.borderColor = [[UIColor lightGrayColor]CGColor];
                desText.layer.borderWidth = 0.5;
                desText.layer.cornerRadius = 10.0f;
                [self addDoneButton];
            }
                break;
                
            default:
                break;
        }
    }
    
    cell.backgroundColor = [UIColor clearColor];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat height = 0;
    switch (indexPath.row) {
        case 0:
            height = 44;
            break;
        case 1:
            height = 44;
            break;
        case 2:
            height = 44;
            break;
        case 3:
            height = 140;
            break;
            
        default:
            break;
    }
    return height;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

@end
