//
//  ViewController.m
//  MiniVKClone
//
//  Created by Антон Дитятив on 22.01.16.
//  Copyright © 2016 Антон Дитятив. All rights reserved.
//

#import "LoginViewController.h"


#define APP_DELEGATE            (AppDelegate *)[[UIApplication sharedApplication] delegate]
#define ROOT_VIEW_CONTROLLER    (PRootViewController *)[APP_DELEGATE rootViewController]
#define SIDE_MENU_CONTROLLER    ((PZSideMenuViewController *)[(PRootViewController *)ROOT_VIEW_CONTROLLER sideMenuViewController])

#define VKid @"5237517"

@interface LoginViewController ()

@end

@implementation LoginViewController

@synthesize loaderActivity = _loaderActivity;
int i = 0;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWasShown:)
                                                 name:UIKeyboardDidShowNotification
                                               object:nil];
    
    NSUserDefaults *session = [NSUserDefaults standardUserDefaults];
    
    self.navigationController.interactivePopGestureRecognizer.enabled = YES;
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"topBarLayer.png"] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
    self.navigationController.navigationBar.translucent = NO;
    
    UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc]
                                       initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
                                       target:nil action:nil];
    negativeSpacer.width = -9;// it was -6 in iOS 6
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 20)];
    
    [titleLabel setText:@"Личный кабинет"];
    [titleLabel setTextColor:[UIColor whiteColor]];
    [titleLabel sizeToFit];
    [self.navigationItem setTitleView:titleLabel];
    [self.view setBackgroundColor:[UIColor colorWithRed:239/255. green:239/255. blue:244/255. alpha:1.0]];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
                                   initWithTarget:self
                                   action:@selector(dismissKeyboard)];
    
    [self.view addGestureRecognizer:tap];
    
//    if ([[session valueForKey:@"user_id"] isEqualToString:@"0"]) {
        [self setupUI];
//    }else {
//        //        [self setupUI2];
//    }
}


-(void)setupUI
{
    SV = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    [SV setBackgroundColor:[UIColor colorWithRed:239/255. green:239/255. blue:244/255. alpha:1.0]];
    [SV setUserInteractionEnabled:YES];
    [SV setScrollEnabled:YES];
    SV.scrollsToTop = YES;
    [self.view addSubview:SV];
    
    UILabel *upTitle = [[UILabel alloc] init];
    [upTitle setFrame:CGRectMake(28, 20, 300, 20)];
    [upTitle setText:@"Войдите через социальную сеть"];
    [upTitle setFont:[UIFont fontWithName:@"HelveticaNeue" size:18]];
    [upTitle setTextColor:[UIColor colorWithRed:109/255. green:109/255. blue:114/255. alpha:1.0]];
    [upTitle sizeToFit];
    [upTitle setFrame:CGRectMake(self.view.frame.size.width/2 - upTitle.frame.size.width/2, 20, upTitle.frame.size.width, upTitle.frame.size.height)];
    [SV addSubview:upTitle];
    
    vkButton = [[UIButton alloc] initWithFrame:CGRectMake(100, upTitle.frame.origin.y + upTitle.frame.size.height + 20, 62, 62)];
    [vkButton setImage:[UIImage imageNamed:@"ic_vk"] forState:UIControlStateNormal];
    [vkButton setImage:[UIImage imageNamed:@"ic_vk_fitback"] forState:UIControlStateHighlighted];
    [vkButton setImage:[UIImage imageNamed:@"ic_vk_fitback"] forState:UIControlStateSelected];
    [vkButton addTarget:self action:@selector(vkAuth) forControlEvents:UIControlEventTouchUpInside];
    [SV addSubview:vkButton];
    
    CALayer*layer = [CALayer layer];
    [layer setFrame:CGRectMake(-5, 43, 401, 2)];
    [layer setBackgroundColor:[UIColor colorWithRed:201/255. green:200/255. blue:205/255. alpha:1.0].CGColor];
    [email.layer addSublayer:layer];
    
    UIView *downLine = [[UIView alloc] initWithFrame:CGRectMake(0, pass.frame.origin.y + pass.frame.size.height, self.view.frame.size.width, 1)];
    [downLine setBackgroundColor:[UIColor colorWithRed:220/255. green:220/255. blue:220/255. alpha:1.0]];
    [SV addSubview:downLine];

    
    _loaderActivity = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    _loaderActivity.center = CGPointMake(self.view.frame.size.width/2,self.view.frame.size.height/2-self.navigationController.navigationBar.frame.size.height/2);
    [self.view addSubview:_loaderActivity];
}

-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    if (textField.tag == 1) {
        textField.secureTextEntry = YES;
        [login setEnabled:YES];
        [login setBackgroundColor:[UIColor colorWithRed:58/255. green:190/255. blue:239/255. alpha:1.0]];
    }
}

-(void)textFieldDidEndEditing:(UITextField *)textField
{
    if (textField.tag==0) {
        if (![self NSStringIsValidEmail:textField.text]) {
            if (textField.text.length > 0) {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Неправильно введен email" message:@"Введите email в формате xxxx@xxxx.ru" delegate:self cancelButtonTitle:nil otherButtonTitles:@"Ок", nil];
                if ([pass.text isEqualToString:@"Пароль"]) {
                    pass.secureTextEntry = NO;
                }else pass.secureTextEntry = YES;
                [alert show];
            }
            textField.text = @"Email";
        }
        if ([self NSStringIsValidEmail:textField.text]) {
            textField.text = [textField.text lowercaseString];
        }
    }
    if (textField.tag==1) {
        if (textField.text.length < 6 && textField.text.length > 0) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Внимание" message:@"Пароль должен быть не менее 6 символов, введите пароль заново" delegate:self cancelButtonTitle:nil otherButtonTitles:@"Ок", nil];
            [alert show];
            textField.text = @"Пароль";
            pass.secureTextEntry = NO;
            [login setEnabled:NO];
            [login setBackgroundColor:[UIColor colorWithRed:58/255. green:190/255. blue:239/255. alpha:0.5]];
        }else if (textField.text.length == 0) {
            textField.text = @"Пароль";
            pass.secureTextEntry = NO;
            [login setEnabled:NO];
            [login setBackgroundColor:[UIColor colorWithRed:58/255. green:190/255. blue:239/255. alpha:0.5]];
        }else {
            [login setEnabled:YES];
            [login setBackgroundColor:[UIColor colorWithRed:58/255. green:190/255. blue:239/255. alpha:1.0]];
        }
    }
}

-(BOOL) NSStringIsValidEmail:(NSString *)checkString
{
    BOOL stricterFilter = NO;
    NSString *stricterFilterString = @"[A-Z0-9a-z\\._%+-]+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2,4}";
    NSString *laxString = @".+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2}[A-Za-z]*";
    NSString *emailRegex = stricterFilter ? stricterFilterString : laxString;
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:checkString];
}

-(void)vkAuth
{
    [vkButton setImage:[UIImage imageNamed:@"vk_active.png"] forState:UIControlStateNormal];
    access_token = [[NSUserDefaults standardUserDefaults] objectForKey:@"VKAccessToken"];
    if (access_token) {
        
    }else {
        NSString *authorizationLink = [NSString stringWithFormat:@"http://api.vk.com/oauth/authorize?client_id=%@&scope=wall,offline&redirect_uri=http://api.vk.com/blank.html&display=touch&response_type=token",VKid];
        NSURL *url = [NSURL URLWithString:authorizationLink];
        loginWebView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, 464, 1024)];
        loginWebView.delegate = self;
        loginWebView.scalesPageToFit = YES;
        [loginWebView setUserInteractionEnabled:YES];
        loginWebView.hidden = NO;
        loginWebView.tag = 2;
        [self.view addSubview:loginWebView];
        [loginWebView loadRequest:[NSURLRequest requestWithURL:url]];
        
        self.navigationItem.leftBarButtonItem = nil;
        
        self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
        
        UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc] initWithTitle:@"Назад" style:UIBarButtonItemStylePlain target:self action:@selector(cancelButtonPressed)];
        
        [self.navigationItem setLeftBarButtonItem:cancelButton animated:YES];
    }
}

-(BOOL)userHasAccessToTwitter
{
//    return [SLComposeViewController isAvailableForServiceType:SLServiceTypeTwitter];
    return NO;
}

//-(void)login
//{
//    [_loaderActivity startAnimating];
//    [[PAPI sharedPAPI] authWithCompletion:^(NSArray *responseAuth, NSError *error) {
//        if ([[responseAuth valueForKey:@"err_code"] isEqualToNumber:[NSNumber numberWithInt:6]]) {
//            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Внимание!" message:@"Введен неверный email или пароль!" delegate:self cancelButtonTitle:nil otherButtonTitles:@"Ок", nil];
//            [alert show];
//            [login setBackgroundColor:[UIColor colorWithRed:58/255. green:190/255. blue:239/255. alpha:0.5]];
//            [login setEnabled:NO];
//            [_loaderActivity stopAnimating];
//        }else {
//            NSUserDefaults *session = [NSUserDefaults standardUserDefaults];
//            [session setObject:email.text forKey:@"userEmail"];
//            [session setObject:pass.text forKey:@"userPass"];
//            [session setValue:[responseAuth valueForKey:@"user_id"] forKey:@"user_id"];
//            [session setValue:[responseAuth valueForKey:@"user_type"] forKey:@"user_type"];
//            [session setValue:[responseAuth valueForKey:@"name"] forKey:@"name"];
//            [session setValue:[responseAuth valueForKey:@"surname"] forKey:@"surname"];
//            [session setValue:@"" forKey:@"socialType"];
//            [session setValue:@"" forKey:@"socialId"];
//
//            if ([[responseAuth valueForKey:@"user_type"] isEqualToString:@"6"]) {
//                NSMutableArray *orderArray = [[session valueForKey:@"order"] mutableCopy];
//                NSMutableDictionary *corp = [[NSMutableDictionary alloc] initWithObjectsAndKeys:@"Корпоративная газета", @"ru", @"Corp", @"en", @"1", @"visible", @"8", @"category", nil];
//                [orderArray addObject:corp];
//
//                [session setValue:orderArray forKey:@"order"];
//
//                [session synchronize];
//                [[NSNotificationCenter defaultCenter] postNotificationName:@"orderChange" object:nil];
//                [[NSNotificationCenter defaultCenter] postNotificationName:@"pressedButton" object:nil];
//            }
//
//            [session synchronize];
//            [_loaderActivity stopAnimating];
//
//            PHomeViewController *homeViewController = [[PHomeViewController alloc] init];
//            UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:homeViewController];
//            [SIDE_MENU_CONTROLLER presentCenterViewController:navController animated:YES];
//
//            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Поздравляем!" message:@"Вход выполнен!" delegate:self cancelButtonTitle:nil otherButtonTitles:@"Ок", nil];
//            [alert show];
//        }
//    } WithEmail:email.text WithPassword:pass.text];
//}

//-(void)registration
//{
//    //    RegistrationViewController *controller = [[RegistrationViewController alloc] init];
//    //    [self.navigationController pushViewController:controller animated:YES];
//    PAgreementViewController *controller = [[PAgreementViewController alloc] init];
//    [self.navigationController pushViewController:controller animated:YES];
//
//}
//
-(void)cancelButtonPressed
{
    [loginWebView removeFromSuperview];
    [vkButton setImage:[UIImage imageNamed:@"ic_vk"] forState:UIControlStateNormal];
    [_loaderActivity stopAnimating];
    
    self.navigationItem.leftBarButtonItem = nil;
    
    UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc]
                                       initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
                                       target:nil action:nil];
    negativeSpacer.width = -9;// it was -6 in iOS 6
    
    
    UIImage *leftImage = [UIImage imageNamed:@"ic_menu"];
    UIButton *leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [leftButton setImage:leftImage forState:UIControlStateNormal];
    [leftButton setFrame:CGRectMake(0, 0, leftImage.size.width, leftImage.size.height)];
    UIBarButtonItem *menuButton = [[UIBarButtonItem alloc] initWithCustomView:leftButton];
    [self.navigationItem setLeftBarButtonItems:[NSArray arrayWithObjects: negativeSpacer, menuButton, nil]];
}

-(void)webViewDidFinishLoad:(UIWebView *)webView {
    
    if (loginWebView.tag == 2) {
        [vkButton setImage:[UIImage imageNamed:@"ic_vk_fitback"] forState:UIControlStateNormal];
        [_loaderActivity startAnimating];
        
        access_token = [self stringBetweenString:@"access_token="
                                       andString:@"&"
                                     innerString:[[[webView request] URL] absoluteString]];
        
        NSArray *userAr = [[[[webView request] URL] absoluteString] componentsSeparatedByString:@"&user_id="];
        user_id = [userAr lastObject];
        
        if(user_id){
            [[NSUserDefaults standardUserDefaults] setObject:user_id forKey:@"VKAccessUserId"];
        }
        
        if (access_token) {
            [[NSUserDefaults standardUserDefaults] setObject:access_token forKey:@"VKAccessToken"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            
            UIImage *image = [UIImage imageNamed:@"iTunesArtwork.png"];
            user_id = [[NSUserDefaults standardUserDefaults] objectForKey:@"VKAccessUserId"];
            access_token = [[NSUserDefaults standardUserDefaults] objectForKey:@"VKAccessToken"];
            
            NSString *urlString = [NSString stringWithFormat:@"https://api.vk.com/method/users.get?uid=%@&access_token=%@", user_id, access_token] ;
            NSURL *url = [NSURL URLWithString:urlString];
            NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
            NSHTTPURLResponse *response = nil;
            NSError *error = nil;
            NSData *responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
            
            NSError *jsonParsingError = nil;
            NSArray *userInfo = [NSJSONSerialization JSONObjectWithData:responseData options:0 error:&jsonParsingError];
            NSString *firstName = [[[userInfo valueForKey:@"response"] valueForKey:@"first_name"] lastObject];
            NSString *lastName = [[[userInfo valueForKey:@"response"] valueForKey:@"last_name"] lastObject];
            
            NSUserDefaults *session = [NSUserDefaults standardUserDefaults];
            [session setObject:firstName forKey:@"name"];
            [session setObject:lastName forKey:@"surname"];
            [session synchronize];
            
            // Этап 1
            NSString *getWallUploadServer = [NSString stringWithFormat:@"https://api.vk.com/method/photos.getWallUploadServer?owner_id=%@&access_token=%@", user_id, access_token];
            
            NSDictionary *uploadServer = [self sendRequest:getWallUploadServer withCaptcha:NO];
            
            // Получаем ссылку для загрузки изображения
            NSString *upload_url = [[uploadServer objectForKey:@"response"] objectForKey:@"upload_url"];
            
            // Этап 2
            // Преобразуем изображение в NSData
            NSData *imageData = UIImageJPEGRepresentation(image, 1.0f);
            
            NSDictionary *postDictionary = [self sendPOSTRequest:upload_url withImageData:imageData];
            
            // Из полученного ответа берем hash, photo, server
            NSString *hash = [postDictionary objectForKey:@"hash"];
            NSString *photo = [postDictionary objectForKey:@"photo"];
            NSString *server = [postDictionary objectForKey:@"server"];
            
            // Этап 3
            // Создаем запрос на сохранение фото на сервере вконтакте, в ответ получим id фото
            NSString *saveWallPhoto = [NSString stringWithFormat:@"https://api.vk.com/method/photos.saveWallPhoto?owner_id=%@&access_token=%@&server=%@&photo=%@&hash=%@", user_id, access_token,server,photo,hash];
            
            NSDictionary *saveWallPhotoDict = [self sendRequest:saveWallPhoto withCaptcha:NO];
            
            NSDictionary *photoDict = [[saveWallPhotoDict objectForKey:@"response"] lastObject];
            NSString *photoId = [photoDict objectForKey:@"id"];
            
            // Этап 4
            // Постим изображение на стену пользователя
            NSString *postToWallLink = [NSString stringWithFormat:@"https://api.vk.com/method/wall.post?owner_id=%@&access_token=%@&message=%@&attachment=%@", user_id, access_token, [self URLEncodedString:@"«Энергия без границ» — приложение об энергетике в России и в мире. https://itunes.apple.com/ru/app/energia-bez-granic/id893194778?mt=8"], photoId];
            
            if ([[session valueForKey:@"everLoggedVk"] isEqual:@"no"]) {
                NSDictionary *postToWallDict = [self sendRequest:postToWallLink withCaptcha:NO];
                NSString *errorMsg = [[postToWallDict  objectForKey:@"error"] objectForKey:@"error_msg"];
                if(errorMsg) {
                    [self sendFailedWithError:errorMsg];
                }
            }
            
            [[API sharedAPI] socialRegisterWithCompletion:^(NSArray *responseRegister, NSError *error) {
                [session setValue:[responseRegister valueForKey:@"user_id"] forKey:@"user_id"];
                [session setValue:[responseRegister valueForKey:@"user_type"] forKey:@"user_type"];
                [session setValue:@"yes" forKeyPath:@"social"];
                [session setValue:@"vk" forKeyPath:@"socialType"];
                [session setValue:user_id forKeyPath:@"socialId"];
                [session setValue:@"yes" forKey:@"everLoggedVk"];
                
                if ([[responseRegister valueForKey:@"user_type"] isEqualToString:@"6"]) {
                    NSMutableArray *orderArray = [[session valueForKey:@"order"] mutableCopy];
                    NSMutableDictionary *corp = [[NSMutableDictionary alloc] initWithObjectsAndKeys:@"Корпоративная газета", @"ru", @"Corp", @"en", @"1", @"visible", @"8", @"category", nil];
                    [orderArray addObject:corp];
                    
                    [session setValue:orderArray forKey:@"order"];
                    
                    [session synchronize];
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"orderChange" object:nil];
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"pressedButton" object:nil];
                }
                
                [session synchronize];
                [_loaderActivity stopAnimating];
                
//                RootViewController *homeViewController = [[RootViewController alloc] init];
//                UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:homeViewController];
//                //                [SIDE_MENU_CONTROLLER presentCenterViewController:navController animated:YES];
//                [self presentViewController:navController animated:YES completion:nil];
                
                [self sendSuccessWithMessage:@"Вы авторизованы под учетной записью VK!"];
            } WithClientId:user_id WithSocialType:@"vk"];
            [loginWebView removeFromSuperview];
        }
    }
}

-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    self.receivedData = data;
}

-(void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    [_loaderActivity startAnimating];
    NSString *htmlSTR = [[NSString alloc] initWithData:self.receivedData
                                              encoding:NSUTF8StringEncoding];
    access_token = [self stringBetweenString:@"access_token\":\"" andString:@"\"}" innerString:htmlSTR];
    NSUserDefaults *session = [NSUserDefaults standardUserDefaults];
    [session setObject:access_token forKey:@"OKAccessToken"];
    [session synchronize];
    
    if (access_token && i==0) {
        
        i=1;
        
        //        NSString *prefix = [NSString stringWithFormat:@"%@%@", access_token, OKSecretKey];
        //        NSString *md5 = [prefix MD5String];
        //        md5 = [md5 lowercaseString];
        //
        //        NSString *posfix = [NSString stringWithFormat:@"application_key=%@method=users.getCurrentUser%@", OKPublicKey, md5];
        //        md5 = [posfix MD5String];
        //        md5 = [md5 lowercaseString];
        
        NSString *sign;
        //        sign=[NSString stringWithFormat:@"%@", md5];
        
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
        //        [request setURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://api.odnoklassniki.ru/fb.do?application_key=%@&method=users.getCurrentUser&access_token=%@&sig=%@", OKPublicKey, access_token, sign]]];
        [request setHTTPMethod:@"GET"];
        NSError *error = [[NSError alloc] init];
        NSHTTPURLResponse *responseCode = nil;
        NSData *oResponseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&responseCode error:&error];
        
        NSString *result = [[NSString alloc] initWithData:oResponseData encoding:NSUTF8StringEncoding];
        if (result) {
            NSString *okId = [self stringBetweenString:@"uid\":\"" andString:@"\"" innerString:result];
            user_id = okId;
            NSString *okFirstName = [self stringBetweenString:@"first_name\":\"" andString:@"\"" innerString:result];
            NSString *okLastName = [self stringBetweenString:@"last_name\":\"" andString:@"\"" innerString:result];
            NSUserDefaults *session = [NSUserDefaults standardUserDefaults];
            [session setObject:okId forKey:@"OKAccessUserId"];
            [session setObject:okFirstName forKey:@"name"];
            [session setObject:okLastName forKey:@"surname"];
            [session synchronize];
            
//            [[PAPI sharedPAPI] socialRegisterWithCompletion:^(NSArray *responseRegister, NSError *error) {
//                [session setValue:[responseRegister valueForKey:@"user_id"] forKey:@"user_id"];
//                [session setValue:[responseRegister valueForKey:@"user_type"] forKey:@"user_type"];
//                [session setValue:@"yes" forKey:@"social"];
//                [session setValue:@"ok" forKey:@"socialType"];
//                [session setValue:user_id forKey:@"socialId"];
//                
//                if ([[responseRegister valueForKey:@"user_type"] isEqualToString:@"6"]) {
//                    NSMutableArray *orderArray = [[session valueForKey:@"order"] mutableCopy];
//                    NSMutableDictionary *corp = [[NSMutableDictionary alloc] initWithObjectsAndKeys:@"Корпоративная газета", @"ru", @"Corp", @"en", @"1", @"visible", @"8", @"category", nil];
//                    [orderArray addObject:corp];
//                    
//                    [session setValue:orderArray forKey:@"order"];
//                    
//                    [session synchronize];
//                    [[NSNotificationCenter defaultCenter] postNotificationName:@"orderChange" object:nil];
//                    [[NSNotificationCenter defaultCenter] postNotificationName:@"pressedButton" object:nil];
//                }
//                
//                [session synchronize];
//                [_loaderActivity startAnimating];
//                
//                //                PHomeViewController *homeViewController = [[PHomeViewController alloc] init];
//                //                UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:homeViewController];
//                //                [SIDE_MENU_CONTROLLER presentCenterViewController:navController animated:YES];
//                
//                [self sendSuccessWithMessage:@"Вы авторизованы под учетной записью Одноклассники!"];
//            } WithClientId:user_id WithSocialType:@"ok"];
        }
    }
}

-(void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    
}

- (NSString*)stringBetweenString:(NSString*)start
                       andString:(NSString*)end
                     innerString:(NSString*)str
{
    NSScanner* scanner = [NSScanner scannerWithString:str];
    [scanner setCharactersToBeSkipped:nil];
    [scanner scanUpToString:start intoString:NULL];
    if ([scanner scanString:start intoString:NULL]) {
        NSString* result = nil;
        if ([scanner scanUpToString:end intoString:&result]) {
            return result;
        }
    }
    return nil;
}

- (NSDictionary *) sendPOSTRequest:(NSString *)reqURl withImageData:(NSData *)imageData {
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:reqURl]
                                                           cachePolicy:NSURLRequestReloadIgnoringLocalCacheData
                                                       timeoutInterval:60.0];
    // Устанавливаем метод POST
    [request setHTTPMethod:@"POST"];
    
    // Кодировка UTF-8
    [request addValue:@"8bit" forHTTPHeaderField:@"Content-Transfer-Encoding"];
    
    CFUUIDRef uuid = CFUUIDCreate(nil);
    NSString *uuidString = (NSString*)CFBridgingRelease(CFUUIDCreateString(nil, uuid));
    CFRelease(uuid);
    NSString *stringBoundary = [NSString stringWithFormat:@"0xKhTmLbOuNdArY-%@",uuidString];
    NSString *endItemBoundary = [NSString stringWithFormat:@"\r\n--%@\r\n",stringBoundary];
    
    NSString *contentType = [NSString stringWithFormat:@"multipart/form-data;  boundary=%@", stringBoundary];
    
    [request setValue:contentType forHTTPHeaderField:@"Content-Type"];
    
    NSMutableData *body = [NSMutableData data];
    
    [body appendData:[[NSString stringWithFormat:@"--%@\r\n",stringBoundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[@"Content-Disposition: form-data; name=\"photo\"; filename=\"photo.jpg\"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[@"Content-Type: image/jpg\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:imageData];
    [body appendData:[[NSString stringWithFormat:@"%@",endItemBoundary] dataUsingEncoding:NSUTF8StringEncoding]];
    
    // Добавляем body к NSMutableRequest
    [request setHTTPBody:body];
    
    NSData *responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    NSDictionary *dict;
    if(responseData){
        //        dict = [[JSONDecoder decoder] parseJSONData:responseData];
        
        // Если есть описание ошибки в ответе
        NSString *errorMsg = [[dict objectForKey:@"error"] objectForKey:@"error_msg"];
        
        NSLog(@"Server response: %@ \nError: %@", dict, errorMsg);
        
        return dict;
    }
    return nil;
}

- (void)alertView:(UIAlertView *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(isCaptcha && buttonIndex == 1){
        isCaptcha = NO;
        
        UITextField *myTextField = (UITextField *)[actionSheet viewWithTag:33];
        [[NSUserDefaults standardUserDefaults] setObject:myTextField.text forKey:@"captcha_user"];
        NSLog(@"Captcha entered: %@",myTextField.text);
        
        // Вспоминаем какой был последний запрос и делаем его еще раз
        NSString *request = [[NSUserDefaults standardUserDefaults] objectForKey:@"request"];
        
        NSDictionary *newRequestDict =[self sendRequest:request withCaptcha:YES];
        NSString *errorMsg = [[newRequestDict  objectForKey:@"error"] objectForKey:@"error_msg"];
        if(errorMsg) {
            [self sendFailedWithError:errorMsg];
        } else {
            [self sendSuccessWithMessage:@"Капча обработана успешно и запрос выполнен!"];
        }
    }
}

- (NSDictionary *) sendRequest:(NSString *)reqURl withCaptcha:(BOOL)captcha {
    // Если это запрос после ввода капчи, то добавляем в запрос параметры captcha_sid и captcha_key
    if(captcha == YES){
        NSString *captcha_sid = [[NSUserDefaults standardUserDefaults] objectForKey:@"captcha_sid"];
        NSString *captcha_user = [[NSUserDefaults standardUserDefaults] objectForKey:@"captcha_user"];
        // Добавляем к запросу данные для капчи. Не забываем что введенный пользователем текст нужно обработать.
        reqURl = [reqURl stringByAppendingFormat:@"&captcha_sid=%@&captcha_key=%@", captcha_sid, [self URLEncodedString: captcha_user]];
    }
    NSLog(@"Sending request: %@", reqURl);
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:reqURl]
                                                           cachePolicy:NSURLRequestReloadIgnoringLocalCacheData
                                                       timeoutInterval:60.0];
    
    // Для простоты используется обычный запрос NSURLConnection, ответ сервера сохраняем в NSData
    NSData *responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    
    // Если ответ получен успешно, можем его посмотреть и заодно с помощью JSONKit получить NSDictionary
    if(responseData){
        //        NSDictionary *dict = [[JSONDecoder decoder] parseJSONData:responseData];
        
        // Если есть описание ошибки в ответе
        //        NSString *errorMsg = [[dict objectForKey:@"error"] objectForKey:@"error_msg"];
        
        //        NSLog(@"Server response: %@ \nError: %@", dict, errorMsg);
        
        // Если требуется ввод капчи
        //        if([errorMsg isEqualToString:@"Captcha needed"]){
        //            isCaptcha = YES;
        //            // Сохраняем параметры для капчи
        //            NSString *captcha_sid = [[dict objectForKey:@"error"] objectForKey:@"captcha_sid"];
        //            NSString *captcha_img = [[dict objectForKey:@"error"] objectForKey:@"captcha_img"];
        //            [[NSUserDefaults standardUserDefaults] setObject:captcha_img forKey:@"captcha_img"];
        //            [[NSUserDefaults standardUserDefaults] setObject:captcha_sid forKey:@"captcha_sid"];
        //            // Сохраняем url запроса чтобы сделать его повторно после ввода капчи
        //            [[NSUserDefaults standardUserDefaults] setObject:reqURl forKey:@"request"];
        //            [[NSUserDefaults standardUserDefaults] synchronize];
        //
        //            [self getCaptcha];
        //        }
        //
        //        return dict;
    }
    return nil;
}

- (void) getCaptcha {
    NSString *captcha_img = [[NSUserDefaults standardUserDefaults] objectForKey:@"captcha_img"];
    UIAlertView *myAlertView = [[UIAlertView alloc] initWithTitle:@"Введите код:\n\n\n\n\n"
                                                          message:@"\n" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"OK", nil];
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(12.0, 45.0, 130.0, 50.0)];
    imageView.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:captcha_img]]];
    [myAlertView addSubview:imageView];
    
    UITextField *myTextField = [[UITextField alloc] initWithFrame:CGRectMake(12.0, 110.0, 260.0, 25.0)];
    [myTextField setBackgroundColor:[UIColor whiteColor]];
    
    // Отключаем автокорректировку
    myTextField.autocorrectionType = UITextAutocorrectionTypeNo;
    // Отключаем автокапитализацию
    myTextField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    myTextField.tag = 33;
    
    [myAlertView addSubview:myTextField];
    [myAlertView show];
}

- (NSString *)URLEncodedString:(NSString *)str
{
    NSString *result = (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,
                                                                                             (CFStringRef)str,
                                                                                             NULL,
                                                                                             CFSTR("!*'();:@&=+$,/?%#[]"),
                                                                                             kCFStringEncodingUTF8));
    return result;
}

- (void) sendFailedWithError:(NSString *)error {
    if(isCaptcha) return;
    UIAlertView *myAlertView = [[UIAlertView alloc] initWithTitle:@"Ошибка!"
                                                          message:error delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
    [myAlertView show];
}

- (void) sendSuccessWithMessage:(NSString *)message {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Успешно!" message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [alert dismissViewControllerAnimated:YES completion:nil];
    }];
    [alert addAction:ok];
}

-(void)dismissKeyboard {
    [email resignFirstResponder];
    [pass resignFirstResponder];
    [SV setContentSize:CGSizeMake(self.view.frame.size.width, self.view.frame.size.height)];
}

-(void)exit
{
    [_loaderActivity startAnimating];
    
    NSUserDefaults *session = [NSUserDefaults standardUserDefaults];
    
    if ([[session valueForKey:@"user_type"] isEqualToString:@"6"]) {
        NSMutableArray *orderArray = [[session valueForKey:@"order"] mutableCopy];
        for (int i = 0; i < orderArray.count; i++) {
            if ([[[orderArray objectAtIndex:i] valueForKey:@"en"] isEqualToString:@"Corp"]) {
                [orderArray removeObjectAtIndex:i];
                break;
            }
        }
        
        [session setValue:orderArray forKey:@"order"];
        
        [session synchronize];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"orderChange" object:nil];
    }
    
    [session setValue:@"no" forKeyPath:@"social"];
    [session setValue:@"0" forKey:@"user_id"];
    [session setValue:nil forKey:@"name"];
    [session setValue:nil forKey:@"surname"];
    [session setValue:@"0" forKey:@"user_type"];
    [session setValue:nil forKey:@"VKAccessToken"];
    [session setValue:nil forKey:@"OKAccessToken"];
    [session setValue:nil forKey:@"userEmail"];
    [session setValue:nil forKey:@"userPass"];
    [session synchronize];
    
    [_loaderActivity stopAnimating];
    
    //    PHomeViewController *homeViewController = [[PHomeViewController alloc] init];
    //    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:homeViewController];
    //    [SIDE_MENU_CONTROLLER presentCenterViewController:navController animated:YES];
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Внимание!" message:@"Вы вышли из системы!" delegate:self cancelButtonTitle:nil otherButtonTitles:@"Ок", nil];
    [alert show];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"pressedButton" object:nil];
}

- (void)keyboardWasShown:(NSNotification *)notification {
    keyboardSize = [[[notification userInfo] objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    [SV setContentSize:CGSizeMake(self.view.frame.size.width, self.view.frame.size.height + keyboardSize.height)];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
