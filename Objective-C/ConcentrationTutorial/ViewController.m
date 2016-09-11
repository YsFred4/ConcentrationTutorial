//
//  ViewController.m
//  ConcentrationTutorial
//
//  Created by Todd Bernhard on 9/2/16.
//  Copyright © 2016 No Tie. All rights reserved.
//


#import "ViewController.h"

@interface ViewController ()

@end

BOOL ipad;
id deviceType;
NSString * fontstring;
NSString * appTitle;
NSString * alertTitle;
NSString * alertMessage;
id fontcolor;
UIView * topMenuView;
UILabel * topTitle;
NSInteger baselevel, level, maxlevel, screenwidth, screenheight, maxcolumn, maxrow, barheight, fontsize, buttonsize, picWidth, picHeight, lastChoice, numMoves, gridsize;

NSMutableArray * imageArray;
NSMutableArray * gridArray;
NSMutableArray * revealedArray;

UIButton * settingsButton;
UIButton * helpButton;
UIView * gridView;
UIAlertView * alert;

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self initializeVariables];
    [self resetGrid];
    [self showMenus];
    [self showGrid];
    [self showAll];
}

-(void)initializeVariables {
    level = 1;
    baselevel = 1;
    maxlevel = 10;
    
    deviceType = [UIDevice currentDevice].model;
    if ([deviceType isEqualToString:@"iPad"]) { ipad = true;}
    else { ipad = false;}
    
    fontstring = @"MarkerFelt-Wide";
    fontcolor = [UIColor blackColor];
    
    CGRect screenBound = [[UIScreen mainScreen] bounds];
    CGSize screenSize = screenBound.size;
    screenwidth = screenSize.width;
    screenheight = screenSize.height;
    
    fontsize = 24;
    barheight = 60;
    buttonsize = 60;
    picWidth = 60;
    picHeight = 100;
    
    if (ipad) {picWidth = 2 * picWidth;picHeight = 2 * picHeight;}
    
//    appTitle = @"Concentration";
    appTitle = @"Match the Candidates";
    imageArray = [[NSMutableArray alloc] initWithObjects:@"Ben Carson",@"Bernie Sanders",@"Bobby Jindal",@"Carly Fiorina",@"Chris Christie",@"Donald Trump",@"George Pataki",@"Hillary Clinton",@"Jeb Bush",@"Jim Gilmore",@"Jim Webb",@"John Kasich",@"Lawrence Lessig",@"Lincoln Chafee",@"Lindsey Graham",@"Marco Rubio",@"Martin O'Malley",@"Mike Huckabee",@"Rand Paul",@"Rick Perry",@"Rick Santorum",@"Scott Walker",@"Ted Cruz",nil];

    NSString * bundleID = [[[NSBundle mainBundle] bundleIdentifier] lowercaseString];

    if ([bundleID isEqualToString:@"com.notiesw.matchpresidents"]) {
        appTitle = @"Match the Presidents";
        imageArray = [[NSMutableArray alloc] initWithObjects:@"AJohnson",@"Arthur",@"BenHarrison",@"Buchanan",@"Carter",@"Cleveland",@"Clinton",@"Coolidge",@"Eisenhower",@"FDRoosevelt",@"Fillmore",@"Ford",@"GHWBush",@"GWBush",@"Garfield",@"Grant",@"Harding",@"Hayes",@"Hoover",@"JQAdams",@"Jackson",@"Jefferson",@"JohnAdams",@"Kennedy",@"LBJohnson",@"Lincoln",@"Madison",@"McKinley",@"Monroe",@"Nixon",@"Obama",@"Pierce",@"Polk",@"Reagan",@"TRoosevelt",@"Taft",@"Taylor",@"Truman",@"Tyler",@"VanBuren",@"WHHarrison",@"Washington",@"Wilson",nil];
    }
    
    if ([bundleID isEqualToString:@"com.notiesw.pokematch"]) {
        appTitle = @"PokeMatch";
        imageArray = [[NSMutableArray alloc] initWithObjects:@"abra",@"aerodactyl",@"alakazam",@"arbok",@"arcanine",@"articuno",@"beedrill",@"bellsprout",@"blastoise",@"bulbasaur",@"butterfree",@"caterpie",@"chansey",@"charizard",@"charmander",@"charmeleon",@"clefable",@"clefairy",@"cloyster",@"cubone",@"dewgong",@"diglett",@"ditto",@"dodrio",@"doduo",@"dragonair",@"dragonite",@"dratiniaganime",@"drowzee",@"dugtrio",@"eevee",@"ekans",@"electabuzz",@"electrode",@"exeggcute",@"exeggutor",@"farfetchd",@"fearow",@"flareon",@"gastly",@"gengar",@"geodude",@"gloom",@"golbat",@"goldeen",@"golduck",@"golem",@"graveler",@"grimer",@"growlithe",@"gyarados",@"haunter",@"hitmonchan",@"hitmonlee",@"horsea",@"hypno",@"ivysaur",@"jigglypuff",@"jolteon",@"jynx",@"kabuto",@"kabutops",@"kadabra",@"kakuna",@"kangaskhan",@"kingler",@"koffing",@"krabby",@"lapras",@"lickitung",@"machamp",@"machop",@"magikarp",@"magmar",@"magnemite",@"magneton",@"mankey",@"marowak",@"metapod",@"mewtwo",@"moltres",@"mr.mime",@"muk",@"nidoking",@"nidoqueen",@"nidoran",@"nidorina",@"nidorino",@"ninetales",@"oddish",@"omanyte",@"omastar",@"onix",@"paras",@"parasect",@"persian",@"pidgeot",@"pidgeotto",@"pidgey",@"pikachu",@"pinsir",@"poliwag",@"poliwhirl",@"poliwrath",@"ponyta",@"porygon",@"primeape",@"psyduck",@"raichu",@"rapidash",@"raticate",@"rattata",@"rhydon",@"rhyhorn",@"sandshrew",@"sandslash",@"scyther",@"seaking",@"seel",@"shellder",@"slowbro",@"slowpoke",@"snorlax",@"spearow",@"squirtle",@"starmie",@"staryu",@"tangela",@"tauros",@"tentacool",@"tentacruel",@"vaporeon",@"venomoth",@"venonat",@"venusaur",@"victreebel",@"vileplume",@"voltorb",@"vulpix",@"wartortle",@"weedle",@"weepinbell",@"weezing",@"wigglytuff",@"zapdos",@"zubat",nil];
    }


}

-(void)resetGrid {
        lastChoice = -1;
        numMoves = 0;
        gridArray = [[NSMutableArray alloc] init];
        revealedArray = [[NSMutableArray alloc] init];
        
        switch (level) {
            case 1 : gridsize = 4; maxcolumn = 2; break;
            case 2 : gridsize = 6; maxcolumn = 3; break;
            case 3 : gridsize = 8; maxcolumn = 4; break;
            case 4 : gridsize = 12; maxcolumn = 4; break;
            case 5 : gridsize = 16; maxcolumn = 4; break;
            case 6 : gridsize = 20; maxcolumn = 5; break;
            case 7 : gridsize = 24; maxcolumn = 6; break;
            case 8 : gridsize = 30; maxcolumn = 6; break;
            case 9 : gridsize = 36; maxcolumn = 6; break;
            case 10 : gridsize = 42; maxcolumn = 7; break;
            case 11 : gridsize = 48; maxcolumn = 8; break;
        }
        
        int ctroffset = (arc4random() % imageArray.count);
        
        for (NSInteger ctr = 0; ctr < gridsize; ctr++) {
            [revealedArray setObject:@"0" atIndexedSubscript:ctr];
            [gridArray setObject:@"" atIndexedSubscript:ctr];
        }
        
        for (NSInteger ctr = 0; ctr < gridsize/2; ctr++) {
            
            NSInteger fixedctr = ctr + ctroffset;
            if (fixedctr >= imageArray.count) {fixedctr = ctr + ctroffset - imageArray.count;}
            
            NSString * object = [imageArray objectAtIndex:fixedctr];
            
            int pos1 = (arc4random() % gridsize);
            BOOL notFree = true;
            while (notFree) {
                if ([[gridArray objectAtIndex:pos1] isEqualToString:@""]) {
                    notFree = false;
                    [gridArray setObject:object atIndexedSubscript:pos1];
                }
                else {
                    pos1++;
                    if (pos1 >= gridsize) {pos1 = 0;}
                }
            }
            
            int pos2 = (arc4random() % gridsize);
            notFree = true;
            while (notFree) {
                if ([[gridArray objectAtIndex:pos2] isEqualToString:@""]) {
                    notFree = false;
                    [gridArray setObject:object atIndexedSubscript:pos2];
                }
                else {
                    pos2++;
                    if (pos2 >= gridsize) {pos2 = 0;}
                }
            }
        }
    }



-(void)showMenus {
    [topMenuView removeFromSuperview];
    topMenuView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, screenwidth, barheight)];
    topMenuView.backgroundColor = [UIColor blackColor];

    topTitle = [[UILabel alloc] initWithFrame:CGRectMake(barheight, 0, screenwidth-2*barheight, barheight)];
    topTitle.textAlignment = NSTextAlignmentCenter;
    topTitle.textColor = [UIColor whiteColor];
    topTitle.font = [UIFont fontWithName:fontstring size:fontsize];
    topTitle.numberOfLines = 0;
    topTitle.adjustsFontSizeToFitWidth = YES;
    topTitle.userInteractionEnabled = NO;
    topTitle.text = appTitle;
    [topMenuView addSubview:topTitle];
    
    helpButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [helpButton setFrame:CGRectMake(0, 0, buttonsize, buttonsize)];
    [helpButton setImage:[UIImage imageNamed:@"Help.png"] forState:UIControlStateNormal];
    [helpButton addTarget:self action:@selector(showHelp) forControlEvents:UIControlEventTouchUpInside];
    helpButton.accessibilityIdentifier = @"Help";
    
    [topMenuView addSubview:helpButton];
    [self.view addSubview:topMenuView];
}

-(void)showGrid {
    
    [gridView removeFromSuperview];
    gridView = [[UIView alloc] initWithFrame:CGRectMake(0, barheight, screenwidth, screenheight-barheight)];
    gridView.clipsToBounds = YES;
    gridView.backgroundColor =  [UIColor colorWithPatternImage:[UIImage imageNamed:@"greenfeltsmall.jpg"]];
    
    maxrow = gridsize/maxcolumn;
    
    picWidth = screenwidth / (maxcolumn + 1);
    picHeight = picWidth * 4/3;
    
    float xspacing = (screenwidth - maxcolumn*picWidth)/maxcolumn;
    float ymargin = xspacing;
    
    NSInteger column, row, i, offset;
    
    column = 0;
    row = 0;
    i = 0;
    NSString *item;
    
    offset = (screenwidth - (maxcolumn*buttonsize))/(1+maxcolumn);
    UIImage * bgImage = [UIImage imageNamed:@"PlayingCardBack.png"];
    
    while (i < gridArray.count) {
        item = [gridArray objectAtIndex:i];
        
        UIImage * thisImage = [UIImage imageNamed:[NSString stringWithFormat:@"%@.png",[gridArray objectAtIndex:i]]];
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.backgroundColor = [UIColor clearColor];
        button.frame = CGRectMake(xspacing/2+column*(picWidth+xspacing), row*(picHeight+ymargin)+ymargin, picWidth, picHeight);
        [[button imageView] setContentMode: UIViewContentModeScaleAspectFit];
        if ([[revealedArray objectAtIndex:i] isEqualToString:@"1"]) {
            [button setImage:[thisImage stretchableImageWithLeftCapWidth:0.0 topCapHeight:0.0] forState:UIControlStateNormal];
        }
        else {[button setBackgroundImage:[bgImage stretchableImageWithLeftCapWidth:0.0 topCapHeight:0.0] forState:UIControlStateNormal];}
        
        button.accessibilityLabel = [NSString stringWithFormat:@"%ld",(long)i];
        [button addTarget:self action:@selector(choseButton:) forControlEvents:UIControlEventTouchUpInside];
        button.tag = i;
        [gridView addSubview:button];
        column++;
        if (column >= maxcolumn) {column=0;row++;}
        i++;
    }
    [self.view addSubview:gridView];
}



-(void)choseButton:(id) sender  {
    UIButton *thisbutton = (UIButton *)sender;
    NSInteger choice = thisbutton.tag;
    NSString * chosenImage = [NSString stringWithFormat:@"%@.png",[gridArray objectAtIndex:choice]];
    
    topTitle.text = [NSString stringWithFormat:@"%@: %@",appTitle,[[gridArray objectAtIndex:choice] uppercaseString]];
    
    if (![[revealedArray objectAtIndex:choice] isEqualToString:@"1"]) {
        numMoves++;
        [revealedArray setObject:@"1" atIndexedSubscript:choice];
        [self showGrid];
        if (lastChoice == -1) { lastChoice = choice;
        }
        else {
            if (!(lastChoice == choice) && ([[gridArray objectAtIndex:lastChoice] isEqualToString:[gridArray objectAtIndex:choice]])) {
                lastChoice = -1;
                BOOL done = true;
                for (int tmpctr = 0; tmpctr < revealedArray.count; tmpctr++) {
                    if ([[revealedArray objectAtIndex:tmpctr] isEqualToString:@"0"]) {done = false;}
                }
                if (done) {
                    if (level < maxlevel) {level++;}
                    [self showDone];
                }
                topTitle.text = appTitle;
            }
            else { // reset revealed
                [self showGrid];
                [revealedArray setObject:@"0" atIndexedSubscript:choice];
                [revealedArray setObject:@"0" atIndexedSubscript:lastChoice];
            }
            lastChoice = -1;
        }
    }
    
    // briefly show image
    
    float duration = 0.5;
    
    UIImageView * animatedOverlay = [[UIImageView alloc] initWithFrame:CGRectMake(0, barheight, screenwidth, screenheight-barheight)];
    
    NSMutableArray * imgArray = [[NSMutableArray alloc] init];
    [imgArray addObject:[UIImage imageNamed:chosenImage]];
    animatedOverlay.animationImages = imgArray;
    animatedOverlay.animationDuration = duration; // seconds
    animatedOverlay.animationRepeatCount = 1; // 0 = loops forever
    [animatedOverlay startAnimating];
    [[self view] addSubview:animatedOverlay];
}

-(void)showAll {
    
    float duration = imageArray.count/5;
    
    UIImageView * animatedOverlay = [[UIImageView alloc] initWithFrame:CGRectMake(0, barheight, screenwidth, screenheight-barheight)];
    
    NSMutableArray * imgArray = [[NSMutableArray alloc] init];
    
    for (int ctr = 0; ctr < imageArray.count; ctr++) {
        NSString * chosenImage = [NSString stringWithFormat:@"%@.png",[imageArray objectAtIndex:ctr]];
        [imgArray addObject:[UIImage imageNamed:chosenImage]];
    }

 animatedOverlay.animationImages = imgArray;
    animatedOverlay.animationDuration = duration; // seconds
    animatedOverlay.animationRepeatCount = 1; // 0 = loops forever
    [[self view] addSubview:animatedOverlay];
    [animatedOverlay startAnimating];

}


-(void)showDone {
    topTitle.text = [NSString stringWithFormat:@"%@: %ld Moves",appTitle,(long)numMoves];
    alertTitle = [NSString stringWithFormat:@"SOLVED in %ld MOVES!",(long)numMoves];
    if (level == maxlevel) { alertMessage = @"Well done! Try again!"; }
    else { alertMessage = [NSString stringWithFormat:@"Well done! Now try again, at level %ld",(long)level]; }
    [self showAlert];
    [self resetGrid];
    [self showGrid];
}


-(void)showHelp {
    alertTitle = [NSString stringWithFormat:@"Welcome to %@!",appTitle];
    alertMessage = @"Select a Level";
    alert = [[UIAlertView alloc] initWithTitle:alertTitle message:alertMessage delegate:nil cancelButtonTitle:@"Continue" otherButtonTitles:@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9",@"10",nil];
    alert.delegate = self;
    [alert show];
}


-(void)showAlert {
    alert = [[UIAlertView alloc] initWithTitle:alertTitle message:alertMessage delegate:nil cancelButtonTitle:@"Continue" otherButtonTitles:nil];
    alert.delegate = self;
    [alert show];
}


- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
    NSString *buttonTitle = [[alertView buttonTitleAtIndex:buttonIndex] lowercaseString];
    //    if ([buttonTitle isEqualToString:@"settings"]) {[self showSettings];}
    
    if ([buttonTitle integerValue] > 0) {
        level = [buttonTitle integerValue];
        [self resetGrid];
        [self showGrid];
    }
    if ([buttonTitle isEqualToString:@"continue"]) {}
    if ([buttonTitle isEqualToString:@"exit"]) {exit(1);}
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
