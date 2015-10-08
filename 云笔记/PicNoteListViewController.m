//
//  PicNoteListViewController.m
//  云笔记
//
//  Created by 079 on 14-11-26.
//  Copyright (c) 2014年 wzc. All rights reserved.
//

#import "PicNoteListViewController.h"
#import "PicTodoDB.h"
#import "ASIHTTPRequest.h"
#import "ASIFormDataRequest.h"
#import "ASINetworkQueue.h"
#import "PicDetailViewController.h"
#import "ActivityIndicator.h"

#define SERVICE_URL @"http://192.168.106.14:8080/"

@interface PicNoteListViewController () {
    PicTodoDB *picTodoDB;
    ASINetworkQueue *netqueue;
    NSString *userName;
    
    NSMutableDictionary *parseDic;
    NSMutableString *parseStr;
    NSArray *elementArray;
    
    NSIndexPath *theIndexPath;
    ActivityIndicator *activityIndicator;
    
    BOOL flag;
}

@end

@implementation PicNoteListViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.tabBarItem.title = @"相册";
        self.tabBarItem.image = [UIImage imageNamed:@"tabbar1.png"];
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(loginsuccess:) name:@"loginsuccess" object:nil];
        // Custom initialization
    }
    return self;
}

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationItem.leftBarButtonItem = self.editButtonItem;
    UIImageView *backImageView = [[UIImageView alloc]initWithFrame:self.view.frame];
    backImageView.image = [UIImage imageNamed:@"addpic.png"];
    self.tableView.backgroundView = backImageView;
    
    NSString *filePath = [NSString stringWithFormat:@"%@/Documents/pic",NSHomeDirectory()];
    picTodoDB = [[PicTodoDB alloc]initWithFilePath:filePath];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"同步" style:UIBarButtonItemStyleDone target:self action:@selector(synchImage)];
    
    netqueue = [[ASINetworkQueue alloc]init];
    netqueue.delegate = self;
    netqueue.maxConcurrentOperationCount = 1;
    [netqueue setQueueDidFinishSelector:@selector(queueDidFinishSelector)];
    
    activityIndicator = [[ActivityIndicator alloc]initWithView:self.view];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)viewWillAppear:(BOOL)animated {
    [picTodoDB read];
    [self.tableView reloadData];
}

- (void)loginsuccess:(NSNotification *)notification {
    userName = [[notification userInfo]objectForKey:@"name"];
}

- (void)synchImage {
    UIActionSheet *actionSheet = [[UIActionSheet alloc]initWithTitle:@"同步" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"上传",@"下载", nil];
    [actionSheet showInView:self.view];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    switch (buttonIndex) {
        case 0:
            [self upPic];
            break;
        case 1:
            [self downPic];
            break;
            
        default:
            break;
    }
}

- (void)upPic {
    flag = YES;
    [activityIndicator show];
    [netqueue cancelAllOperations];
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@service/startimagenotesync?user_name=%@",SERVICE_URL,userName]];
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];
    [request setTimeOutSeconds:10.0];
    [request startSynchronous];
    if (![request error]) {
        NSString *responseStr = [request responseString];
        NSRange statusRange = [responseStr rangeOfString:@"<status>"];
        if (statusRange.length <= 0) {
            return;
        }
        NSRange rangeStr1 = NSMakeRange(statusRange.location+8, 1);
        if ([[responseStr substringWithRange:rangeStr1] isEqualToString:@"1"]) {
            NSRange syncRange1 = [responseStr rangeOfString:@"<sync_id>"];
            NSRange syncRange2 = [responseStr rangeOfString:@"</sync_id>"];
            NSRange sync_idRange = NSMakeRange(syncRange1.location+syncRange1.length, syncRange2.location-(syncRange1.location+syncRange1.length));
            NSString *sync_id = [responseStr substringWithRange:sync_idRange];
            NSURL *upurl = [NSURL URLWithString:[NSString stringWithFormat:@"%@service/uploaduserimagenote?user_name=%@",SERVICE_URL,userName]];
            for (PicTodo *todo in picTodoDB.picTodoList.picTodoArray) {
                ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:upurl];
                [request setDelegate:self];
                [request setDidFinishSelector:@selector(requestIfError:)];
                [request setPostValue:sync_id forKey:@"sync_id"];
                [request setPostValue:[NSString stringWithFormat:@"%d",todo.imageID] forKey:@"image_id"];
                [request setFile:todo.pictureName forKey:@"file"];
                [request setPostValue:todo.todoDescription forKey:@"image_note"];
                [netqueue addOperation:request];
                [netqueue go];
            }
        }else {
            NSRange messageRange1 = [responseStr rangeOfString:@"<message>"];
            NSRange messageRange2 = [responseStr rangeOfString:@"</message>"];
            NSRange errorRange = NSMakeRange(messageRange1.location+messageRange1.length, messageRange2.location-(messageRange1.location+messageRange1.length));
            NSString *errorStr = [responseStr substringWithRange:errorRange];
            UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"同步失败" message:errorStr delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
            [alertView show];
        }
    }else {
        [activityIndicator miss];
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"上传失败" message:@"请检查网络连接" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alertView show];
    }
}

- (void)downPic {
    [activityIndicator show];
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@service/downloaduserimagenote?user_name=%@",SERVICE_URL,userName]];
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];
    [request setTimeOutSeconds:10.0];
    request.delegate = self;
    [request startAsynchronous];
}

- (void)requestFailed:(ASIHTTPRequest *)request {
    [activityIndicator miss];
    UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"下载失败" message:@"请检查网络设置" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
    [alertView show];
}

- (void)requestFinished:(ASIHTTPRequest *)request {
    [activityIndicator miss];
    if (![request error]) {
        NSData *xmlData = [request responseData];
        NSXMLParser *parser = [[NSXMLParser alloc]initWithData:xmlData];
        parser.delegate = self;
        [parser parse];
    }
}

- (void)requestIfError:(ASIHTTPRequest *)request {
    if (![request error]) {
        NSString *str = [request responseString];
        NSRange statusRange = [str rangeOfString:@"<status>"];
        NSRange rangeStr1 = NSMakeRange(statusRange.location+statusRange.length, 1);
        NSString *str1 = [str substringWithRange:rangeStr1];
        if ([str1 isEqualToString:@"0"]) {
            NSRange messageRange1 = [str rangeOfString:@"<message>"];
            NSRange messageRange2 = [str rangeOfString:@"</message>"];
            NSRange errorRange = NSMakeRange(messageRange1.location+messageRange1.length, messageRange2.location-(messageRange1.location+messageRange1.length));
            NSString *errorStr = [str substringWithRange:errorRange];
            UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"上传失败" message:errorStr delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
            [alertView show];
            flag = NO;
        }
    }
}

- (void)queueDidFinishSelector {
    [activityIndicator miss];
    if (flag) {
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"上传成功" message:@"" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alertView show];
    }
}

#pragma mark - NSXMLParserDelegate
- (void)parserDidStartDocument:(NSXMLParser *)parser {
    parseDic = [[NSMutableDictionary alloc]init];
    parseStr = [[NSMutableString alloc]init];
    
    elementArray = [NSArray arrayWithObjects:@"pictureNote",@"imageName",@"imageId", nil];
}

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict {
    if ([elementName isEqualToString:@"item"]) {
        [parseDic removeAllObjects];
    }else if ([elementArray containsObject:elementName]) {
        [parseStr setString:@""];
    }
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string {
    [parseStr appendString:string];
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName {
    if ([elementArray containsObject:elementName]) {
        [parseDic setObject:[NSString stringWithString:parseStr] forKey:elementName];
    }else if ([elementName isEqualToString:@"item"]) {
        NSData *imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:[parseDic objectForKey:@"imageName"]]];
        PicTodo *newtodo = [[PicTodo alloc]initWithImage:imageData andDescription:[parseDic objectForKey:@"pictureNote"]];
        NSString *picName = [[parseDic objectForKey:@"imageName"]lastPathComponent];
        NSString *pictureName = [NSString stringWithFormat:@"%@/Documents/%@",NSHomeDirectory(),picName];
        [picTodoDB addTodo:newtodo withName:pictureName];
    }
}

- (void)parserDidEndDocument:(NSXMLParser *)parser {
    NSFileManager *fm = [NSFileManager defaultManager];
    for (PicTodo *todo in picTodoDB.picTodoList.picTodoArray) {
        if ([fm fileExistsAtPath:todo.pictureName]) {
            [fm removeItemAtPath:todo.pictureName error:nil];
        }
    }
    for (PicTodo *todo in picTodoDB.picTodoList.picTodoArray) {
        [todo.imageData writeToFile:todo.pictureName atomically:YES];
    }
    [picTodoDB write];
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
//#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
//#warning Incomplete method implementation.
    // Return the number of rows in the section.
    return [picTodoDB cout];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        //cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell = [[[NSBundle mainBundle]loadNibNamed:@"picCell" owner:self options:nil]lastObject];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.backgroundColor = [UIColor clearColor];
    }
    PicTodo *todo = [picTodoDB picTodoAtIndex:indexPath.row];
    
    UIImageView *imageView = (UIImageView *)[cell viewWithTag:100];
    UITextView *textView = (UITextView *)[cell viewWithTag:101];
    
    imageView.image = [UIImage imageWithData:todo.imageData];
    //imageView.contentMode = UIViewContentModeScaleAspectFit;
    imageView.layer.masksToBounds = YES;
    imageView.layer.borderColor = [[UIColor greenColor]CGColor];
    imageView.layer.borderWidth = 1.0f;
    imageView.layer.cornerRadius = 7.0f;
    textView.text = todo.todoDescription;
    textView.editable = NO;
    textView.backgroundColor = [UIColor clearColor];
    textView.userInteractionEnabled = NO;
    // Configure the cell...
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 68;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/


// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"删除" message:@"" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:@"取消", nil];
        [alertView show];
        theIndexPath = indexPath;
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 0) {
        NSFileManager *fm = [NSFileManager defaultManager];
        if ([fm fileExistsAtPath:[[picTodoDB picTodoAtIndex:theIndexPath.row]pictureName]]) {
            [fm removeItemAtPath:[[picTodoDB picTodoAtIndex:theIndexPath.row]pictureName] error:nil];
        }
        [picTodoDB removePicTodoAtIndex:theIndexPath.row];
        [picTodoDB write];
        [self.tableView deleteRowsAtIndexPaths:@[theIndexPath] withRowAnimation:UITableViewRowAnimationFade];
    }else {
        [self.tableView setEditing:NO animated:YES];
    }
}

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/


#pragma mark - Table view delegate

// In a xib-based application, navigation from a table can be handled in -tableView:didSelectRowAtIndexPath:
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    PicDetailViewController *viewController = [[PicDetailViewController alloc]init];
    viewController.imageData = [[picTodoDB picTodoAtIndex:indexPath.row]imageData];
    viewController.textSting = [[picTodoDB picTodoAtIndex:indexPath.row]todoDescription];
    [self.navigationController pushViewController:viewController animated:YES];
}
 


@end
