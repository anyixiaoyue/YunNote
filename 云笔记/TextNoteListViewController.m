//
//  TextNoteListViewController.m
//  云笔记
//
//  Created by 079 on 14-11-26.
//  Copyright (c) 2014年 wzc. All rights reserved.
//

#import "TextNoteListViewController.h"
#import "AddTextNoteViewController.h"
#import "ActivityIndicator.h"

#define SERVER_URL @"http://192.168.106.14:8080"

@interface TextNoteListViewController () {
    NSMutableArray *mutableArray;
    NSIndexPath *index;
    NSMutableString *parseStr;
    NSMutableArray *parseArray;
    NSMutableDictionary *parseDic;
    NSArray *elementArray;
    
    NSURLConnection *upConnection;
    NSURLConnection *downConnection;
    
    NSString *userName;
    ActivityIndicator *activityIndicator;
}

@end

@implementation TextNoteListViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.tabBarItem.title = @"笔记";
        self.tabBarItem.image = [UIImage imageNamed:@"tabbar4.png"];
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
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:self.view.frame];
    imageView.image = [UIImage imageNamed:@"textnote.png"];
    self.tableView.backgroundView = imageView;
    NSString *filePath = [NSString stringWithFormat:@"%@/Documents/todo",NSHomeDirectory()];
    self.todoDB = [[ToDoDB alloc]initWithFileName:filePath];
    [self.todoDB read];
    
    UIRefreshControl *refreshControl = [[UIRefreshControl alloc]init];
    [self.tableView addSubview:refreshControl];
    [refreshControl addTarget:self action:@selector(refresh:) forControlEvents:UIControlEventValueChanged];
    //self.navigationController.navigationBar.barTintColor = [UIColor blueColor];
    
    mutableArray = [[NSMutableArray alloc]initWithArray:self.todoDB.todoList.todolistArray];

    UISearchBar *searchBar = [[UISearchBar alloc]initWithFrame:CGRectMake(0, 0, 320, 40)];
    self.tableView.tableHeaderView = searchBar;
    
    searchBar.delegate = self;
    searchBar.showsBookmarkButton = YES;
    searchBar.showsCancelButton = YES;
    
    self.navigationItem.leftBarButtonItem = self.editButtonItem;
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addTextNote)];
    
    //self.navigationController.toolbarHidden = NO;
    UISegmentedControl *segment = [[UISegmentedControl alloc]initWithItems:[NSArray arrayWithObjects:@"subject",@"priority",@"date", nil]];
    [segment addTarget:self action:@selector(segmentValueChanged:) forControlEvents:UIControlEventValueChanged];
    UIBarButtonItem *spaceItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
    UIBarButtonItem *segmentItem = [[UIBarButtonItem alloc]initWithCustomView:segment];
    UIBarButtonItem *upItem = [[UIBarButtonItem alloc]initWithTitle:@"Up" style:UIBarButtonItemStyleDone target:self action:@selector(uploadTodo)];
    UIBarButtonItem *downItem = [[UIBarButtonItem alloc]initWithTitle:@"Down" style:UIBarButtonItemStyleDone target:self action:@selector(downloadTodo)];
    self.toolbarItems = [NSArray arrayWithObjects:upItem,spaceItem,segmentItem,spaceItem,downItem, nil];
    
    activityIndicator = [[ActivityIndicator alloc]initWithView:self.view];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)viewWillAppear:(BOOL)animated {
    self.navigationController.toolbarHidden = NO;
}

- (void)loginsuccess:(NSNotification *)notification {
    userName = [[notification userInfo]objectForKey:@"name"];
}

- (void)uploadTodo {
    [activityIndicator show];
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/service/uploadusernote?user_name=%@",SERVER_URL,userName]];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL:url];
    NSString *str = [self todoToXMLString:self.todoDB];
    NSData *xmlData = [str dataUsingEncoding:NSUTF8StringEncoding];
    [request setHTTPBody:xmlData];
    [request setHTTPMethod:@"POST"];
    [request setValue:[NSString stringWithFormat:@"%d",xmlData.length] forHTTPHeaderField:@"Content-Length"];
    [request setTimeoutInterval:10.0];
    upConnection = [[NSURLConnection alloc]initWithRequest:request delegate:self];
}

- (void)downloadTodo {
    [activityIndicator show];
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/service/downloadusernote?user_name=%@",SERVER_URL,userName]];
    NSURLRequest *request = [[NSURLRequest alloc]initWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10.0];
    
    downConnection = [[NSURLConnection alloc]initWithRequest:request delegate:self];
}

- (NSString *)todoToXMLString:(ToDoDB *)tododb {
    NSMutableString *str = [[NSMutableString alloc]init];
    [str appendString:@"<?xml version=\"1.0\" encoding=\"utf-8\"?>\n"];
    [str appendString:@"<rss version=\"2.0\">\n"];
    for (Todo *todo in tododb.todoList.todolistArray) {
        [str appendString:@"\t<todo>\n"];
        [str appendFormat:@"\t\t<subject>%@</subject>\n",todo.subject];
        [str appendFormat:@"\t\t<tododescription>%@</tododescription>\n",todo.todoDescription];
        [str appendFormat:@"\t\t<priority>%d</priority>\n",todo._priority];
        [str appendFormat:@"\t\t<date>%@</date>\n",todo._date];
        [str appendString:@"\t</todo>\n"];
    }
    [str appendString:@"</rss>\n"];
    return str;
}

- (void)segmentValueChanged:(UISegmentedControl *)segment {
    switch (segment.selectedSegmentIndex) {
        case 0:
            [self.todoDB sortSubject];
            [mutableArray setArray:self.todoDB.todoList.todolistArray];
            break;
        case 1:
            [self.todoDB sortPriority];
            [mutableArray setArray:self.todoDB.todoList.todolistArray];
            break;
        case 2:
            [self.todoDB sortDate];
            [mutableArray setArray:self.todoDB.todoList.todolistArray];
            break;
            
        default:
            break;
    }
    [self.tableView reloadData];
}

- (void)addTextNote {
    AddTextNoteViewController *viewController = [[AddTextNoteViewController alloc]init];
    viewController.todoDB = self.todoDB;
    [self.navigationController pushViewController:viewController animated:YES];
}

- (void)refresh:(UIRefreshControl *)refreshControl {
    [self performSelector:@selector(endRefresh:) withObject:refreshControl afterDelay:0.5];
}

- (void)endRefresh:(UIRefreshControl *)refreshControl {
    [refreshControl endRefreshing];
    [self.todoDB read];
    [mutableArray setArray:self.todoDB.todoList.todolistArray];
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - NSURLConnectionDelegate
- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:[error.userInfo objectForKey:@"NSLocalizedDescription"] message:@"" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
    [alertView show];
    [activityIndicator miss];
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    [activityIndicator miss];
    NSString *str = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
    if ([connection isEqual:downConnection]) {
        NSRange statusrange = [str rangeOfString:@"<status>"];
        if (statusrange.length > 0) {
            NSRange str1range = NSMakeRange(statusrange.location+statusrange.length, 1);
            NSString *str1 = [str substringWithRange:str1range];
            if ([str1 isEqualToString:@"0"]) {
                NSRange messagerange1 = [str rangeOfString:@"<message>"];
                NSRange messagerange2 = [str rangeOfString:@"</message>"];
                NSRange errorrange = NSMakeRange(messagerange1.location+messagerange1.length, messagerange2.location - (messagerange1.location+messagerange1.length));
                NSString *errorStr = [str substringWithRange:errorrange];
                UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"下载失败" message:errorStr delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
                [alertView show];
            }
        }
        NSXMLParser *parser = [[NSXMLParser alloc]initWithData:data];
        parser.delegate = self;
        [parser parse];
    }else {
        NSRange range = [str rangeOfString:@"<status>"];
        if (range.length <= 0) {
            UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"Error" message:@"" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
            [alertView show];
            return;
        }
        NSRange range1 = NSMakeRange(range.location+8, 1);
        NSString *str1 = [str substringWithRange:range1];
        if ([str1 isEqualToString:@"1"]) {
            UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"上传成功" message:@"" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
            [alertView show];
        }else {
            NSRange messagerange1 = [str rangeOfString:@"<message>"];
            NSRange messagerange2 = [str rangeOfString:@"</message>"];
            NSRange errorrange = NSMakeRange(messagerange1.location+messagerange1.length, messagerange2.location - (messagerange1.location+messagerange1.length));
            NSString *errorStr = [str substringWithRange:errorrange];
            UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"上传失败" message:errorStr delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
            [alertView show];
        }
    }
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    
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
    return [mutableArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    Todo *tmptodo = [mutableArray objectAtIndex:indexPath.row];
    cell.textLabel.text = tmptodo.subject;
    cell.backgroundColor = [UIColor clearColor];
    // Configure the cell...
    
    return cell;
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
        index = indexPath;
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"删除" message:@"" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:@"取消", nil];
        [alertView show];
        //[tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 0) {
        
        [self.todoDB removeToDo:[self.todoDB indexOfToDo:[mutableArray objectAtIndex:index.row]]];
        //[mutableArray setArray:self.todoDB.todoList.todolistArray];
        [mutableArray removeObjectAtIndex:index.row];
        [self.todoDB write];
        [self.tableView deleteRowsAtIndexPaths:@[index] withRowAnimation:UITableViewRowAnimationFade];
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
    AddTextNoteViewController *viewController = [[AddTextNoteViewController alloc]init];
    viewController.todo = [mutableArray objectAtIndex:indexPath.row];
    viewController.todoDB = self.todoDB;
    [self.navigationController pushViewController:viewController animated:YES];
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
}
 


#pragma mark - UISearchBarDelegate

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    [mutableArray removeAllObjects];
    if ([searchText length] > 0) {
        for (Todo *obj in self.todoDB.todoList.todolistArray) {
            if ([obj.subject hasPrefix:searchText]) {
                [mutableArray addObject:obj];
            }
        }
    }else {
        [mutableArray setArray:self.todoDB.todoList.todolistArray];
    }
    [self.tableView reloadData];       
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    [mutableArray setArray:self.todoDB.todoList.todolistArray];
    [self.tableView reloadData];
    [searchBar resignFirstResponder];
}

-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    [searchBar resignFirstResponder];
}

#pragma mark - NSXMLParserDelegate

- (void)parserDidStartDocument:(NSXMLParser *)parser {
    parseStr = [[NSMutableString alloc]init];
    parseArray = [[NSMutableArray alloc]init];
    elementArray = [NSArray arrayWithObjects:@"subject",@"tododescription",@"priority",@"date", nil];
}

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict {
    if ([elementName isEqualToString:@"todo"]) {
        parseDic = [[NSMutableDictionary alloc]init];
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
    }else if ([elementName isEqualToString:@"todo"]) {
        Todo *todo = [[Todo alloc]initWithTodo:[parseDic objectForKey:@"subject"] andtodoDescription:[parseDic objectForKey:@"tododescription"] andpriority:[[parseDic objectForKey:@"priority"]integerValue] anddate:[parseDic objectForKey:@"date"]];
        [parseArray addObject:todo];
    }
}

- (void)parserDidEndDocument:(NSXMLParser *)parser {
    self.todoDB.todoList.todolistArray = [NSMutableArray arrayWithArray:parseArray];
    [mutableArray setArray:self.todoDB.todoList.todolistArray];
    [self.tableView reloadData];
    [self.todoDB write];
}

@end
