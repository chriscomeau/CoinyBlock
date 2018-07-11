//
//  CBSkinManager.m
//  CoinBlock
//
//  Created by Chris Comeau on 2016-04-07.
//  Copyright © 2016 Skyriser Media. All rights reserved.
//

#import "CBSkinManager.h"

@implementation CBSkinManager

+(NSString*)getRandomStart:(int)index {

    //disabled
    //return @"Press Start!";

    BOOL skinOnly = NO;

    //skin?
    NSArray *skinArray = nil;

    if(index == kCoinTypeDefault) {
        //skinArray = @[]; //empty
    }

    else if(index == kCoinTypeFlat) {
        //skinArray = @[]; //empty
    }

    else if(index == kCoinTypeMega) {
        skinOnly = YES;

        skinArray = @[@"Mission start!"];
        skinArray = @[@"Mission start!"];
        skinArray = @[@"Mission start!"];
        skinArray = @[@"Mission start!"];
    }

    else if(index == kCoinTypeMine) {

        //skinArray = @[]; //empty
    }

    else if(index == kCoinTypeMetal) {

        //skinArray = @[]; //empty
    }

    else if(index == kCoinTypeYoshi) {
        //skinArray = @[]; //empty
    }

    else if(index == kCoinTypeSonic) {
        //skinArray = @[]; //empty
    }

    else if(index == kCoinTypePew) {
        skinOnly = YES;

        skinArray = @[
                @"Brofist!",

                @"100%",

                @"Fabulous!",
                @"Fabulous!",
                @"Fabulous!",
                @"Fabulous!",


                @"Bessie the beast!",

                //@"Alright alright!",
                @"Zero deaths!",

                @"Let's Play!",
                @"Let's Play!",
                @"Let's Play!",
                @"Let's Play!",

                @"Lets Do This!",
                @"Lets Do This!",
                @"Lets Do This!",

                @"Let's Watch!",

                //@"5 weird things!",
                //@"5 Weird Stuff!",
            ];
    }

    else if(index == kCoinTypeZelda) {
        //skinArray = @[]; //empty
    }

    else if(index == kCoinTypeBitcoin) {
        //skinArray = @[]; //empty
    }

    else if(index == kCoinTypeMac) {
        //skinArray = @[]; //empty
    }

    else if(index == kCoinTypeFlap) {

        skinOnly = YES;
        skinArray = @[
                      @"Get Ready!",
                      @"Get Ready!",
                      @"Get Ready!",

					  @"Tap tap tap!",
					  @"Tap tap tap!",
					  @"Tap tap tap!",
                      ];
    }

    else if(index == kCoinTypeMario) {
        skinOnly = YES;
        skinArray = @[
                      @"Let's go!",
                      @"Here we go!",
					  //@"Andiamo!", //lets go
                      ];
    }

    else if(index == kCoinTypeGameboy) {
        //skinArray = @[]; //empty
    }
    else if(index == kCoinTypeZoella) {
			skinArray = @[
										//@"Yay!",

										@"Cute!",
										//@"amazing",
										@"Brilliant!",

										];


    }

    else if(index == kCoinTypeMontreal) {
        //skinArray = @[]; //empty
    }

    else if(index == kCoinTypeTA) {
        skinOnly = YES;

        //skinArray = @[@"Put that on the box!"];
        skinArray = @[@"Tap to Hodapp!", @"Meow!", @"Stick around!"];
    }

    else if(index == kCoinTypeBrain) {

        skinOnly = YES;

        skinArray = @[
                      @"Beware, I live!",
                      //@"Beware!",
                      //@"Enter!", if you dare
                      @"Stay a while!",
                      @"Ha ha ha!",
                      @"Prepare to die.",
                      @"I hunger.",
                      ];
    }

    else if(index == kCoinTypeNyan) {
        skinArray = @[@"Purr!", @"Meow!"];
    }
    else if(index == kCoinTypeEmoji) {
        //skinArray = @[]; //empty
    }
    else if(index == kCoinTypeValentine) {
        //skinArray = @[]; //empty
    }
    else if(index == kCoinTypePatrick) {
        //skinArray = @[]; //empty
    }
    else if(index == kCoinTypeSoccer) {
        skinArray = @[@"Goal!"]; //empty
    }
    else {
        //default
        //Log(@"getRandomStart: default");
    }

    //just skins
//    if(skinArray && skinArray.count > 0) {
//        return [skinArray randomObject];
//    }


    //if not, regular


#if 1
    NSArray *messageArray =
    @[
      @"Press start!",
      ];
#else
    NSArray *messageArray =
    @[
      @"Tap to Start!",
      @"Tap to Start!",
      @"Tap to Start!",

      @"1P Start!",
      @"1P Start!",

      //@"Push start!",
      //@"Push start!",

      @"Press start!",
      @"Press start!",

      @"Press B to start!",

      @"Press fire!",
      //@"Press any button!",

      //@"Press A!",
      //@"Press A!",

      @"Continue!",
      @"Continue!",

      @"Game start!",
      @"Game start!",

      @"Tap to Play!",
      //@"It's go time!",
      //@"You can do it! ",
      //@"Go for it! ",
      @"Continue!",
      @"Let's go!",

      @"Go!",

      //@"Tap tap tap!",
      //@"Get Ready!",

      //@"Let's dance!",
      //@"We can dance!",

      ];
#endif

    //extras?
    NSMutableArray* messageArrayCustom = nil;

#if 0
    //if(kAppDelegate.level >= 5)
    {
        messageArrayCustom =
        [@[
          @"YOLO!",
          @"Never let go! ",
          @"Lets's do this!",
          @"Engage!",

          //notif
          @"C-O-I-N-S !",
          @"Treat yo self!",

          @"Go go go!",
          @"It's showtime!",

          @"Clickbait!",


          ] mutableCopy];

    }
#endif

    if(!kAppDelegate.inReview) {
        [messageArrayCustom addObjectsFromArray:@[
                                                 // @"Here we go!",
                                                 // @"Here we go!",
                                                  ]];
    }

    if(skinOnly)
    {
        //empty other arrays
        messageArray = @[];
        messageArrayCustom = [@[] mutableCopy];
    }

    NSArray *merged = [messageArray arrayByAddingObjectsFromArray:messageArrayCustom];
    merged = [messageArray arrayByAddingObjectsFromArray:skinArray];

    return [merged randomObject];
}

//+1
+(NSString*)getRandomMessage {

    NSArray *messageArray =
    @[
      @"awesome",
      @"far out",
      @"nice",
      @"sweet",
      @"booyah",
      @"great",
      @"well done",
      @"good",
      @"ch-ching",
      @"like a boss",
      @"bam",
      @"boom",
      @"cool",
      @"tcb",
      @"awesomesauce",
      @"wow",
      @"ah-mah-zing",
      @"legend-ary",
      //@"bazinga",
      @"redic",
      @"cray cray",
      @"omg",
      //@"epic",
      @"winning",
      @"win",
      //@"pwning",
      @"crazy",
      //@"totes mcgoats",
      //@"fo sho",
      @"wicked",
      @"tubular",
	  @"schwing",
      @"awh yeah",
      @"right on",
      @"dude",
      @"scrumtrulescent",
      @"let's go",
      //@"to the moon",
      //@"dyn-o-mite",
      @"stellar",
      @"rad",
      @"rad",
      @"kudos",
      @"hurrah",
      //@"congrats",
      @"wooooh",
      @"groovy",
      //@"mind blown",
      //@"bling bling",
      @"wonderful",
      @"incredible",
      @"marvelous",
      @"neato",
      @"bangin'",
      @"out of sight",
      @"boss",
      @"legit",
      @"righteous",
      @"sick",
      @"whoa",
      @"gnarly",
      @"choice",
      @"fresh",
      @"wicked",
      @"bangin",
      @"big time",
      @"major",
      @"primo",
      @"sportin",
      @"tight",
      //@"100%",
      @"yasss",
      //@"fabulous",
      @"that's right",
      @"nailed it",

      //trailer
      @"decent",
      @"decent",

      //@"viewtiful",

      //kanye
      // @"bro",
      // @"broooooo",

      @"sensational",

      @"super effective",

      @"speyz",

      @"bringo",

      @"nice",
      @"nice",
      @"nice",
      @"nice",

      @"noice",
      @"noice",

      //@"magnificent",
      //@"beautiful",
      //@"extraordinary",
      //@"impressive",
      //@"spectacular",
      //@"stupendous",

      //@"bada bing",
      //@"hey-o",
      //@"yuuup",
      //@"not that bad",
      //@"phat loots",
      //@"what what?",

      ];


    //ultracombo, gratz,


    NSArray *messageArrayCustom = @[];


    //default
    //name = [NSString stringWithFormat:@"Skin %d", index+1];
    int index = (int)[kAppDelegate getSkin];

    if(index == kCoinTypeDefault) {
        //messageArray = @[]; //empty
        //messageArrayCustom = @[];
    }

    else if(index == kCoinTypeFlat) {
        //messageArray = @[]; //empty
        //messageArrayCustom = @[];
    }

    else if(index == kCoinTypeMega) {
        //messageArray = @[]; //empty
        //messageArrayCustom = @[];

        messageArray = @[]; //empty
        messageArrayCustom = @[
            @"that strat",
            @"hype",
            //@"noice",
            @"save the animals",
            @"pb",
            @"gg",
            @"xsplit",
            ];

    }

    else if(index == kCoinTypeMine) {
        //messageArray = @[]; //empty
        //messageArrayCustom = @[];
    }

    else if(index == kCoinTypeMetal) {
        //messageArray = @[]; //empty
        //messageArrayCustom = @[];
    }

    else if(index == kCoinTypeYoshi) {
        //messageArray = @[]; //empty
        //messageArrayCustom = @[];
    }

    else if(index == kCoinTypeSonic) {
        //messageArray = @[]; //empty
        //messageArrayCustom = @[];
    }

    else if(index == kCoinTypePew) {
        messageArray = @[]; //empty
        messageArrayCustom = @[
                    @"100%",
                    @"100%",
                    @"100%",
                    @"100%",
                    @"100%",

                    @"views",
                    @"views",
                    @"views",
                    @"views",
                    @"views",
                    @"views",
                    @"views",
                    @"views",
                    @"views",
                    @"views",
                    @"views",
                    @"views",
                    @"views",
                    @"views",
                    @"views",

                    @"bros",
                    @"bros",
                    @"bros",
                    @"bros",
                    @"bros",
                    @"bros",
                    @"bros",
                    @"bros",
                    @"bros",
                    @"bros",
                    @"bros",


                    @"brofist",
                    @"brofist",
                    @"brofist",
                    @"brofist",

                    @"fabulous",
                    @"fabulous",
                    @"fabulous",

                    @"alright alright",
                    @"alright alright",
                    @"alright alright",

                    @"u get edgar",

                    @"prrrrah",
                    @"prrrrah",
                    @"prrrrah",
                    @"prrrrah",
                    @"prrrrah",

                    @"nailed it",
                    @"nailed it",

                    @"bux",
                    @"bux",

                    @"yes",
                    @"yes",
                    @"yes",

                    @"my point",
                    @"my point",

                    @"vaoep",
                    @"vaoep",

                    @"very cool",
                    @"very cool",

                    @"10/10 IGN",
                    @"10/10 IGN",

                    @"50M subs",
                    @"50M subs",
                    @"50M subs",

                    @"subs",
                    @"subs",
                    @"subs",

                    @"likes",
                    @"likes",
                    @"likes",

                    @"thumbs up",
                    @"thumbs up",

                    @"GOTY",
                    @"GOTY",

                    @"pdp 2020",

                    @"$UP 8ROS?!1",

                    @"kick, punch",

                    @"awesum",
                    @"magd-aaaah",
                    @"good for you",
                    @"video games",
                    @"mlg pro",

                    @"clickbait",

                    @"instakill",

                    @"press the button",

                    @"for sweden",

                    @"oke",

                    //@"like",

                    @"moar",

                    @"salad queen",
                    @"salad king",
                    @"Stredge-ah-dise",

                    @"bessie the beast",
                    //@"marzia",
                    @"woooooh",
                    @"maya",
                    @"edgar",
                    @"notice me senpai",
                    //@"yeah",
                    @"clezzix",

                    @"sick",

                    @"parachutes",

                    //https://www.youtube.com/watch?v=Sy5ewcG8paw
                    @"bra", //good
                    @"smorgastarta",  //cake

                    @"ja",

                    @"cruchnr",


                    @"1080p",
                    @"1080p",

                    @"60 FPS",
                    @"60 FPS",

                    @"cakes",

                    @"baby boy",

                    @"birdabo",

                    @"tandborste",

					//youtube
					//@"lonniedos",
					@"first",
					@"m0:00ar",

                    @"gonzales",
                    @"gonzales",
                    @"gonzales",

                    @"baby steps",
                    @"baby steps",


                ];



        if([kHelpers isFriday]) {

            messageArrayCustom = [messageArrayCustom arrayByAddingObjectsFromArray:@[
                                 @"fdwpdp",
                                 @"fdwpdp",
                                 @"fdwpdp",
                                 @"fdwpdp",
                                 @"fdwpdp",
                                 @"fdwpdp",
                                 @"fdwpdp",
                                 @"fdwpdp",
            ]];
        }

    }

    else if(index == kCoinTypeZelda) {
        //messageArray = @[]; //empty
        //messageArrayCustom = @[];
    }

    else if(index == kCoinTypeBitcoin) {

#if 0
        if(kAppDelegate.bitcoinPrice > 0.0f) {
            //NSString *bitcoinString = [NSString stringWithFormat:@"$%.02fUSD", kAppDelegate.bitcoinPrice];
            NSString *bitcoinString = [NSString stringWithFormat:@"$%d", (int)floor(kAppDelegate.bitcoinPrice)];
            messageArray = @[
                             bitcoinString,
                             bitcoinString,
                             bitcoinString,
                             bitcoinString,
                             bitcoinString,
                             bitcoinString,
                             ];
        }
        else
#endif
            messageArray = @[]; //empty

        messageArrayCustom = @[

                               @"i++",
                               @"i++",
                               @"i++",
                               @"i++",
                               @"i++",
                               @"i++",
                               @"i++",

                               @"c++",
                               @"c++",
                               @"c++",

                               @"moof",
                               @"moof",
                               @"moof",
                               @"moof",

                               @"amazing",
                               @"amazing",
                               @"amazing",

                               @"if",
                               @"else",
                               @"#define",
                               @"void",
                               @"switch",
                               @"assert",
                               @"breakpoint",
                               @"public",
                               @"private",
                               @"TRUE",
                               @"FALSE",
                               @"int",
                               @"class",
                               @"struct",
                               @"enum",
                               @"const",
                               @"guru meditation",
                               @"goto",
                               @"error -43",
                             	 // @"404",
                               @"l33t",

                               @"drawRect",

                               @"#gamedev",
                               @"#indiedev",
                               @"#indiegame",
                               @"#pixelart",
                               @"#indiedevhour",
                               //@"#screenshotsaturday",

                               @"slashdot",
                               @"./",
                               @"cmdrtaco",

                               @"querty",

                               @"0110101",
                               @"0100101",
                               @"1011001",

                               @"wysiwyg",

                               //ios
                               @"#import",
                               @"@property",
                               @"pod install",
                               @"delegate",
                               @"SKSpriteNode",
                               @"viewDidLoad",

                               @"ObjC",
                               @"Swift",

                               //http://www.coindesk.com/information/bitcoin-glossary/
                               @"blockchain",
                               @"BTC",
                               @"BCH", //bitcoin cash
                               @"XRP", //ripple
              							   @"LTC", //litecoin
              							   @"ETH", //ether

                               @"Satoshi",
                               @"SHA-256",


                               @"0x7f8ae163dc20",
                               @"hello world",

                               @";",
                               @"->",
                               @"/.",

                               //@"FreePPP",
                               // @"mafiaboy",
                               // @"heartbleed",
                               //@"wannacry",

                               @"warez",

                               @"hack",
                               @"hack",
                               @"hack",

                               @"botnet",
                               @"ddos",
                               @"irc",
                               @"lulzsec",

							                 @"64-bit",

                               //amiga
                               @"agnus",
                               @"daphne",
                               @"portia",


                               @"woot",

                               ];
    }

    else if(index == kCoinTypeMac) {
        //messageArray = @[]; //empty
        messageArrayCustom = @[
                               ];
    }

    else if(index == kCoinTypeFlap) {
        messageArray = @[]; //empty
        messageArrayCustom = @[
                               @"flap",
                               ];
    }

    else if(index == kCoinTypeMario) {
        //messageArray = @[]; //empty

		messageArrayCustom = @[
		//https://www.mariowiki.com/List_of_Mario_quotes
			@"Mamma mia",
			@"Wa-hoo!",
			@"Yeah! Ha ha ha",
			@"Woo-hoo!",
		];
    }

    else if(index == kCoinTypeGameboy) {
        //messageArray = @[]; //empty
        //messageArrayCustom = @[];
    }
    else if(index == kCoinTypeZoella) {
        messageArray = @[]; //empty
        messageArrayCustom = @[
                               @"cute",
                                @"amazing",
                                @"alfie",
                                @"poppy",
                                @"nala",
                                @"buzz",

                                @"cheers",
                                @"ace",
                                @"brilliant",
                                @"well done",

                               @"UK",
                               @"cosmo",

                               ];
    }

    else if(index == kCoinTypeMontreal) {
        //messageArray = @[]; //empty
        messageArrayCustom = @[
                               @"pas pire",
                               @"poutine",
                               @"go habs go",
                               @"aweye",

								@"yes sir",

                               @"#manifencours",
                               @"#manifencours",
                               @"#manifencours",

                               @"dou dou dou",
                               @"dou dou dou",
                               @"dou dou dou",

                               @"tsé",

                               //@"pas pire",
                               ];
    }
    else if(index == kCoinTypeBrain) {
        //messageArray = @[]; //empty
        //messageArrayCustom = @[];
    }
    else if(index == kCoinTypeTA) {
        //messageArray = @[]; //empty
        messageArrayCustom = @[
                               //@"whatever",
                               @"nice",

                               @"wow wow wow",
                               @"wow wow wow",
                               @"wow wow wow",
                               @"wow wow wow",
                               @"wow wow wow",

                               @"fartface69",
                               @"fartface69",
                               @"fartface69",

                               @"smokeyblunt69",
                               @"smokeyblunt69",

                               @"bongsmoker420",
                               @"bongsmoker420",


                               @"wrestling",
                               @"wrestling",
                               //@"wrestling",

                               @"blake",
                               @"arnold",
                               @"jared",
                               @"jared",
                               @"mike",
                               @"mike",
                               @"eli",
                               @"eli",
                               @"eli",
                               @"carter",
                               @"hodap",
                               @"brad",
                               @"nissa",
                               @"flappiest",

                               @"f2p",
                               @"rogue-like",
                               @"fact-check",
                               @"16-bit",

                               @"radical",
                               @"radical",

                               @"polished",
                               @"polished",
                               @"polished",
                               @"polished",

                               @"addictive",
                               @"addictive",

                               @"son",


                               @"segway",
                               @"segway",

                               @"esla",
                               @"tesla",

                               @"turnt",
                               @"turnt",
                               @"turnt",
                               @"turnt",

                               @"word",
                               @"word",

                               //pets?
                               @"steve",
                               @"pickles",
                               @"rambo",

							   @"32-bit",

								@"juggalo",

								@"pubg",

								/*@"jank",
                                @"jank",

                                @"janky",
                                @"janky",
                                @"janky",*/

								//@"AOE",

                               @"steve",
                               @"steve",
                               @"steve",

                               @"make more",
                               @"make more",


                               @"#poundsign",
                               @"#poundsign",

                               ];
    }

    else if(index == kCoinTypeNyan) {
        messageArray = @[]; //empty
        messageArrayCustom = @[
                               @"meow",
                               @"so wow",
                               @"much coins",

                               ];
    }

    else if(index == kCoinTypeEmoji) {
        messageArray = @[]; //empty
        messageArrayCustom = @[
                               @":)",
                               @":P",

                               @"brb",
                               @"lol",
                               @"omg",
                               @"bff",
                               @"gr8",
                               @"j/k",
                               @"l8r",
                               @"thx",
                               @"xoxo",
                               @"tbh",
                               @"zomg",
                               @"lulz",
                               @"lawl",

                               ];
    }

    else if(index == kCoinTypeValentine) {
        messageArray = @[]; //empty
        messageArrayCustom = @[
                               //@"❤️",
                               @"luv",
                               @"kiss",
                               //@"smooch",
                               @"love you",
                               @"sure love",
                               @"my baby",
                               @"let's kiss",
                               @"be true",
                               @"all mine",
                               @"my girl",
                               @"miss you",
                               ];
    }

    else if(index == kCoinTypePatrick) {
        messageArray = @[]; //empty
        messageArrayCustom = @[
                               @"irish",
                               //@"pat",
                               @"kiss me",
                               @"dublin",
                               @"paddy",
                               
                               
                               @"luck",
                               @"luck",
                               @"luck",
                               
                               ];
    }
    
    else if(index == kCoinTypeSoccer) {
        messageArray = @[]; //empty
        messageArrayCustom = @[
                               @"kick",
                               @"kick",
                               @"kick",
                               
                               @"pass",
                               @"pass",
                               @"pass",
                               
                               @"goal",
                               @"goal",

                               @"score",
                               @"score",
                               ];
    }
    

    else {
        //default
        Log(@"getRandomMessage: default");
    }


    NSArray *merged = [messageArray arrayByAddingObjectsFromArray:messageArrayCustom];
    NSString * message = [merged randomObject];

    assert(message);
    return message;
}

+(NSString*)getRandomOuch {

    NSArray *messageArray = nil;

    //disabled
#if 0
    messageArray = @[
      @"ouch",
      @"ouch",
      @"ouch",

      @"ow",

      @"boo",
      @"boo",

      @"malarkey",
      @"malarkey",

      @"noooooo",
      @"fail",
      @"khaaaaaan",
      @"bummer",
      @"nope",
      //@"buggin",
      @"burn",
      //@"dayum",
      @"lame",
      @"harsh",
      //@"noob",
      @"n00b",
      @"how rude",
      @"scratch",
      @"yikes",
      @"oh jeez",
      //@"ok then",
	  @"not",
	  @"dang it",

      //too long?
      @"shut it down",
      @"huge mistake",

      //@"mamma mia",

      @"@!#?@!",
      @"@!#?@!",

      @"fuhgeddaboudit",

      //@"rekt",

      //wolf3d
      //@"mein leben",

	  @"pwn",
	  @"teabagged",
      @"FML",

      ];
#endif

    //just ouch
    messageArray = @[
                     @"ouch",
                     @"ouch",
                     @"ouch",
      ];


    NSArray *messageArrayCustom = @[];


    //default
    int index = (int)[kAppDelegate getSkin];

    if(index == kCoinTypeDefault) {
        //messageArray = @[]; //empty
        //messageArrayCustom = @[];
    }

    else if(index == kCoinTypeFlat) {
        //messageArray = @[]; //empty
        //messageArrayCustom = @[];
    }

    else if(index == kCoinTypeMega) {
        messageArray = @[]; //empty
        messageArrayCustom = @[
                               @"4444444444",
                               @"oooook gggg",
                               @"pi pi pi",
                               @"waaaaaa",
                               @"rng",
                               ];
    }

    else if(index == kCoinTypeMine) {
        //messageArray = @[]; //empty
        //messageArrayCustom = @[];
    }
    else if(index == kCoinTypeMetal) {
        //messageArray = @[]; //empty
        //messageArrayCustom = @[];
    }

    else if(index == kCoinTypeYoshi) {
        //messageArray = @[]; //empty
        //messageArrayCustom = @[];
    }

    else if(index == kCoinTypeSonic) {
        //messageArray = @[]; //empty
        //messageArrayCustom = @[];
    }

    else if(index == kCoinTypePew) {
        messageArray = @[]; //empty
        messageArrayCustom = @[
                               @"wat",
                               @"wat",
                               @"wat",

                               //what the fuck
                               @"va fan",
                               @"va fan",
                               @"va fan",

                               @"triggered",
                               @"triggered",
                               @"triggered",

                               @"cringe",
                               @"back off",

                               @"rekt",
                               @"rekt",
                               @"rekt",

                               @"whyyyy",
                               @"whyyyy",
                               @"whyyyy",

                               @"bullet ball",


                               //@"behind the giant",
                               @"zero deaths",
                               @"zero deaths",
                               @"zero deaths",

                               @"damnit",
                               @"jumpscare",
                               @"daaaaad",
                               @"sry",
                               @"how",

                               //https://www.youtube.com/watch?v=Sy5ewcG8paw
                               @"fan", //damn
                               @"rumpa", //butt
                               @"kiss", //pee
                               @"brostvarta", //nipple
                               @"javla", //fuck

                               @"fooehhh",
                               @"whoat",
                               @"disappoint",
                               @"you died",

                               @"seadogs",
                               @"seadogs",

                               @"mermaids",
                               @"mermaids",

                               @"subs -1",
                               @"subs -1",
                               @"subs -1",
                               @"subs -1",
                               @"subs -1",

                               @"deal with it",

                               @"of course",
                               @"of course",

                               @"screw you guys",

                               @"roasted",
                               @"roasted",
                               @"roasted",

                               @"destroyed",

							   @"did he died",

                               @"oh shoes",
                               @"oh shoes",
                               @"oh shoes",

                               @"oh shibble",
                               @"oh shibble",

                               @"I hate barrels",
                               @"I hate barrels",
                               @"I hate barrels",

                               @"casual",
                               @"casual",
                               @"casual",

                               @"stop",
                               @"stop",
                               @"stop",

                               ];
    }

    else if(index == kCoinTypeZelda) {
        //messageArray = @[]; //empty
        //messageArrayCustom = @[];

        messageArrayCustom = @[
                               @"hey, listen",
                               @"hey, listen",
                               @"hey, listen",
                               @"hey, listen",
                               ];

    }

    else if(index == kCoinTypeBitcoin) {
        messageArray = @[]; //empty
        messageArrayCustom = @[
                               @"access denied",
                               @"error",
                               @"exception",
                               //@"stack overflow",

                               @"0x8BADF00D",
                               @"0xBAAAAAAD",
                               //@"0xBAD22222",
                               //@"0xC00010FF",
                               //@"0xDEADBEAF",
                               @"0xDEADBEEF",
                               //@"0xDEADFA11",
                               //@"0xFFBADD11",

							   /*
							   400 Bad Request. ...
								401 Unauthorized. ...
								403 Forbidden. ...
								404 Not Found. ...
								500 Internal Server Error. ...
								502 Bad Gateway. ...
								503 Service Unavailable. ...
								504 Gateway Timeout.
							   */
							    @"404",
                             	@"404",
                             	@"404",

                             	@"401",
                             	@"403",
                             	@"500",

                              @"ban",
                              @"eof",
                              @"eod",
                              @"l8r",

                               ];
    }

    else if(index == kCoinTypeMac) {
        //messageArray = @[]; //empty
        messageArrayCustom = @[
                               ];
    }

    else if(index == kCoinTypeFlap) {
        messageArray = @[]; //empty
        messageArrayCustom = @[
                               @"game over",
                               ];
    }

    else if(index == kCoinTypeMario) {
        //messageArray = @[]; //empty

		//https://www.mariowiki.com/List_of_Mario_quotes
        messageArrayCustom = @[
                               @"basta", //enough
                               @"uffa", //annoyed
							   @"i'm-a-tired",
							   @"bye-bye",
							   @"arrivederci",
							   @"hoooooot",
							   @"oh, my head",
                               ];
    }

    else if(index == kCoinTypeGameboy) {
        //messageArray = @[]; //empty
        //messageArrayCustom = @[];
    }
    else if(index == kCoinTypeZoella) {
        //messageArray = @[]; //empty
        messageArrayCustom = @[
															 @"bugger",
															 @"bollocks",
															 @"nice one",
															 @"dodgy",
															 //@"tosh",
															 @"rubbish",
															 @"oh my gosh",
                                                             @"deary me",
															 ];

    }

    else if(index == kCoinTypeMontreal) {
        //messageArray = @[]; //empty
        messageArrayCustom = @[
                               //@"pas pire",

                               @"#manifencours",
                               @"#manifencours",
                               @"#manifencours",

                               @"ayoye",
                               @"ayoye",
                               @"ayoye",

                               ];
    }

    else if(index == kCoinTypeBrain) {
        //messageArray = @[]; //empty
        //messageArrayCustom = @[];
    }

    else if(index == kCoinTypeTA) {
        messageArray = @[]; //empty
        messageArrayCustom = @[
                               //@"1 star",
                               @"whatever",
                               @"jank",
                               @"janky",
                               @"janky",
                               //@"SOL",
                               //@"SOL",
                               @"ridiculous",

                               //@"jared sucks",
                               //@"jared sucks",
                               //@"jared sucks",

							   @"appocalypse",

                               //@"daf*ck",

								@"troll",
								//@"soul crushing",
								@"thugs",
								@"ragequit",
								@"60$",

                              	@"OP",

								//heartstone
								@"face",
								@"nerfed",
								//@"OTK",
								//@"HAHA",

                @"NDA",
                @"NDA",

								//@"BM",
								//@"Dennis",
								//@"hi mom",

                               ];
    }

    else if(index == kCoinTypeNyan) {
        //messageArray = @[]; //empty
        messageArrayCustom = @[
                               //@"meow",
                               ];
    }
    else if(index == kCoinTypeEmoji) {
        messageArray = @[]; //empty
        messageArrayCustom = @[
                               @":(",
                               @"=[",
                               @"o rly?",
                               @"Y_Y",
                               ];
    }
    else if(index == kCoinTypeValentine) {
        messageArray = @[]; //empty
        messageArrayCustom = @[
                               @":(",
                               @"heartbreak",
                               ];
    }
    else if(index == kCoinTypePatrick) {
        messageArray = @[]; //empty
        messageArrayCustom = @[
                               @"hangover",
                               @"puke",
                               ];
    }
    
    else if(index == kCoinTypeSoccer) {
        messageArray = @[]; //empty
        messageArrayCustom = @[
                               @"foul",
                               @"penalty",
                               ];
    }
    

    else {
        if([kHelpers isDebug])
        {
            //assert(0);
        }

        //default
        Log(@"getRandomOuch: default");
    }


    //NSFW
    NSArray *extras2 = @[];
    if(!kAppDelegate.inReview) {
        extras2 =
        @[
          //@"schitt",
          ];

    }


    NSArray *merged = [messageArray arrayByAddingObjectsFromArray:messageArrayCustom];
    merged = [merged arrayByAddingObjectsFromArray:extras2];
    NSString * message = [merged randomObject];

    assert(message);
    return message;
}


+(NSString *)getRandomTip {
    //random tip
    NSString * message = [[self getRandomLongMessage] randomObject];

//    BOOL tempBool = [kHelpers randomBool100:50];
//    NSString *prefix = tempBool?@"PROTIP":@"Lifehack"; //@"Tip";
    NSString* prefix = @"<color1>PROTIP:</color1>";

   //if(prefix)
    message = [NSString stringWithFormat:@"%@ %@", prefix, message];
    //message = [NSString stringWithFormat:@"\"%@\"", message];

   return message;
}

+(NSString *)getRandomWinMessage {

    //NSString *another = @"\nBut more Coins are in\nanother world...";
    //NSString *another = @"";

    NSString *another = @"";
//    if(kAppDelegate.gamecenterName) {
//        another = [NSString stringWithFormat:@", %@", kAppDelegate.gamecenterName];
//    }

    //force test
    //return [NSString stringWithFormat:@"Victory achieved%@!", another];

    NSArray *messageArray =
    @[
        [NSString stringWithFormat:@"Thank you%@!", another],
        [NSString stringWithFormat:@"Congratulations%@!", another],
        [NSString stringWithFormat:@"Great job%@!", another],
        [NSString stringWithFormat:@"Awesome%@!", another],
        //[NSString stringWithFormat:@"Wow%@!", another],
        //[NSString stringWithFormat:@"You win%@!", another],
        [NSString stringWithFormat:@"A winner is you%@!", another],
        [NSString stringWithFormat:@"You did it%@!", another],

        [NSString stringWithFormat:@"Victory achieved%@!", another],

        [NSString stringWithFormat:@"Amazing run%@!", another],


        //[NSString stringWithFormat:@"All clear%@!", another],
        //[NSString stringWithFormat:@"Victory%@!", another],
//        [NSString stringWithFormat:@"Chapter Complete%@!", another],
//        [NSString stringWithFormat:@"Stage Clear%@!", another],
//        [NSString stringWithFormat:@"Course Clear%@!", another],
//        [NSString stringWithFormat:@"Level Clear%@!", another],
        //[NSString stringWithFormat:@"You are the best player%@!", another],
      ];


    NSArray *messageArrayCustom = @[];


    //default
    int index = (int)[kAppDelegate getSkin];

    if(index == kCoinTypeDefault) {
        //messageArray = @[]; //empty
        //messageArrayCustom = @[];
    }

    else if(index == kCoinTypeFlat) {
        //messageArray = @[]; //empty
        //messageArrayCustom = @[];
    }

    else if(index == kCoinTypeMega) {

//			messageArray = @[]; //empty
//			messageArrayCustom = @[
//         [NSString stringWithFormat:@"Mission Complete%@!", another],
//         ];

    }

    else if(index == kCoinTypeMine) {
        //messageArray = @[]; //empty
        //messageArrayCustom = @[];
    }

    else if(index == kCoinTypeMetal) {
        //messageArray = @[]; //empty
        //messageArrayCustom = @[];
    }

    else if(index == kCoinTypeYoshi) {
        //messageArray = @[]; //empty
        //messageArrayCustom = @[];
    }

    else if(index == kCoinTypeSonic) {
        //messageArray = @[]; //empty
        //messageArrayCustom = @[];
    }

    else if(index == kCoinTypePew) {
        messageArray = @[]; //empty
        messageArrayCustom = @[
                               [NSString stringWithFormat:@"Fabulous%@!", another],
                               [NSString stringWithFormat:@"Brofist%@!", another],
                               [NSString stringWithFormat:@"Alright alright%@!", another],
                               [NSString stringWithFormat:@"Very cool%@.", another],
                               ];
    }

    else if(index == kCoinTypeZelda) {
        //messageArray = @[]; //empty
        //messageArrayCustom = @[];
    }

    else if(index == kCoinTypeBitcoin) {
        //messageArray = @[]; //empty
        //messageArrayCustom = @[];
    }

    else if(index == kCoinTypeMac) {
        //messageArray = @[]; //empty
        //messageArrayCustom = @[];
    }

    else if(index == kCoinTypeFlap) {
        //messageArray = @[]; //empty
        //messageArrayCustom = @[];
    }

    else if(index == kCoinTypeMario) {
        //messageArray = @[]; //empty
        //messageArrayCustom = @[];
    }

    else if(index == kCoinTypeGameboy) {
        //messageArray = @[]; //empty
        //messageArrayCustom = @[];
    }
    else if(index == kCoinTypeBrain) {
        //messageArray = @[]; //empty
        //messageArrayCustom = @[];
    }

    else if(index == kCoinTypeZoella) {
			messageArray = @[]; //empty
			messageArrayCustom = @[
             [NSString stringWithFormat:@"Well done%@!", another],
             ];
    }

    else if(index == kCoinTypeMontreal) {
    }

    else if(index == kCoinTypeTA) {
        messageArray = @[]; //empty
        messageArrayCustom = @[
                [NSString stringWithFormat:@"Radical%@!", another],
                [NSString stringWithFormat:@"Wow wow wow%@!", another],
                [NSString stringWithFormat:@"Nice%@!", another],
                [NSString stringWithFormat:@"Well done, son%@!", another],
                               ];
    }

    else if(index == kCoinTypeNyan) {
        //messageArray = @[]; //empty
        //messageArrayCustom = @[];
    }
    else if(index == kCoinTypeEmoji) {
        //messageArray = @[]; //empty
        //messageArrayCustom = @[];
    }

    else if(index == kCoinTypeValentine) {
        //messageArray = @[]; //empty
        //messageArrayCustom = @[];
    }
    else if(index == kCoinTypePatrick) {
        //messageArray = @[]; //empty
        //messageArrayCustom = @[];
    }
    
    else if(index == kCoinTypeSoccer) {
        //messageArray = @[]; //empty
        //messageArrayCustom = @[];
    }
    

    else {
        //default
        Log(@"getRandomWinMessage: default");
    }



    NSArray *merged = [messageArray arrayByAddingObjectsFromArray:messageArrayCustom];
    NSString * message = [merged randomObject];

    return message;
}

+(NSArray *)getRandomLongMessage {

    //test
    //return @[@"test"];

    //tip and notif

    NSArray *messageArray = @[];
    NSArray *extras =
    @[
      @"Click smarter, not harder!",
      @"Click some more!",
      @"Keep on clickin' on!",
      @"Get them Coins!",
      @"More Coins = Awesome!",
      //@"Blocks need clickin'!",
      @"Dolla dolla Coins y'all!",
      @"So wow. Much Coins.",
      @"So many Coins, so little time!",
      @"Give it a little tappy, tap-tap-taperoo!",
      @"The Coins they are a-fallin'.",
      @"Less talking, more clicking'!",
      @"Less tweeting, more clicking'!",
      @"A Coin a day keeps the doctor away.",
      @"Y u no click?",
      @"I got 99 problems but a Coin ain't one.",
      @"Mo Coins mo fun.",
      @"If you liked it, then you shoulda put a Coin on it!",
      @"Clickers gonna click!",
      @"Tapping is half the battle!",
      @"Keep calm and tap on!",
      @"Based on true events.",

      @"Join the Coiny Block fun club today!",

      //pew
      @"The pizza is aggressive.",

      //futurama
      //https://theinfosphere.org/List_of_title_captions
      @"Now with flavor!",
      @"As seen on TV!",
      @"Proudly Made on Earth.",
      @"For external use only.",
      @"Known to cause insanity in laboratory mice.",
      @"Where no Coin has gone before!",
      @"Voted \"best\"",
      @"Voted \"most\"",
      @"Soon to be a hit television show.",
      @"Made From 100% Recycled Pixels",
      @"Spoiler alert: Coins and whatnot.",

      @"There is no Cow Block level.",

      @"All our Coins are Gluten-Free",

      @"640K of RAM recommended.",
      @"256 colors recommended.",
      @"56k modem connection recommended.",
      @"Sound Blaster Pro recommended.",

      //@"Don't turn off while saving.",
      @"Saving game, please don't turn off your console.",

      @"No wireless. Less space than a Nomad. Lame.",

      //@"The morning sun has vanquished the horrible night.",
      //@"What a horrible night to have a curse.",


      ];

    //NSFW
    NSArray *extras2 = @[];
    if(!kAppDelegate.inReview) {
        extras2 =
        @[
          @"Don't copy that floppy.",
          //@"Now available on Sega Genesis!",
          ];
    }

    NSArray *merged = [messageArray arrayByAddingObjectsFromArray:extras];
    merged = [merged arrayByAddingObjectsFromArray:extras];

    return merged;
}

+(NSString *)getRandomReady {

    //return @"Ready";
    return @"Tap to continue";

    /*
    return [@[

             @"Ready",
             @"Ready",

             @"Good luck!",

             ] randomObject];
     */
}


+(NSArray *)getRandomNotification {

    //force
#if 0
    if(NO && [kHelpers isDebug]) {
        return @[
                 @"BEST 👏 GAME 👏 2 0 1 7 🐔",
             ];
    }
#endif

    NSArray *messageArray = @[]; //[self getRandomLongMessage];

    NSArray *extras =
    @[
      //trump
      //@"Huge.",
      //@"Wrong.",
      //@"Tremendus.",


      @"Ch-ching! So many Coins are waiting for you!",
      @"Happy little Coins are waiting for you!",
      @"LOL!",
      @"YOLO!",
      @"OMG!",
      @"TL;DR",
      @"New phone, who dis?",

      @"C-O-I-N-S !",
      @"C-O-I-N-S !",
      @"C-O-I-N-S !",
      @"C-O-I-N-S !",

      @"It's Coin-o-clock!",
      @"That Coin cray!",
      @"Make it rain Coins!",
      @"Chuck Norris can tap faster than you!",
	  @"Chuck Norris counted to infinity. Twice!",
      @"More Coins than meets the eye!",
      @"There are LITERALLY tons of Coins!",
      //@"For your health!",
      //@"Check it out!",
      @"Yo dawg, I heard you like Coins...",
      @"Are you #winning?",
      @"Bigfoot is stealing your Coins!",
      //@"Yeah... So if you could get more Coins, that'd be greeeaat.",
      //@"Hello, it's me...",
      @"Treat yo self!",
      @"Waaaassssssuuuuuupppp!",
      @"What's the time? It's time to get Coins!",
      @"Everything is awesome!",
      //@"Work, work, work, work, work, work!",
      @"Unwindulax!",

      @"Leeroy Jenkins!",

      @"Help me Thomas!",

      @"You've got Coins!",

      @"Time to Coiny Block and chill.",

      @"I [?] Coiny Block!",
      //@"I = A[?]",

      //scott pilgrim
      @"I think there's a thingy over here, somewhere...",

      //@"Howdy Ho!",

      @"Click, click, click, click, click, click...",

      @"That game is so fetch!",


      @"💰💰💰",

      //pokemon
      //@"Oh?",
      @"A wild Coin appears!",

      //cartoon memes
      //@"Dinkleburg!",
      //@"Remember all those Coins? Pepperidge Farm remembers.",
      @"Worse. Notification. Ever.",
      //@"I, for one, welcome our new Coin overlords.",
      //@"....aaand it's gone.",
      //@"If you don't Coiny Block, you're gonna have a bad time!",
      @"Over 9000 Coins!",
      //@"Not sure if...",
      //@"Shut up and take my Coins!",
      @"丂凵尸巳尺 凵乚ㄒ尺卂 ㄒ卄丨匚匚",

      //memes,
      //@"Is this real life?",
      @"All your Coins are belong to us.",
      //@"What you say?",
      //@"Son, I am disappoint.",
      @"One does not simply Coiny Block.",
      @"I can has Coinz?",
      //@"Never gonna give you up, never gonna let you down...",
      @"Coins. Coins everywhere!",
      //@"Well, that escalated quicly!",

      @"Cash me ousside howbow dah?",

      @"Promise me! Don't play this game during work!", //game ad

      @"Double tap for Smell-O-Vision!",

      @"A++ 10/10 would recommend!",

      @"Did you get that thing I sent you?", //harvey birdman

      //game memes
      //@"Sanic, gotta go fast",
      //@"Half-Life 3 confirmed",
      //@"CoinBlock 3 confirmed",
      //@"Giant enemy crab, attack weak point for massive damage",
      //@"Attack its Weak Point for massive damage! 👊 🦀",
      @"Attack its Weak Point for massive damage! 🤜💥",

      @"Command?", //dragon warrior

      @"99% can't play this without feeling physical pain!",

      @"Do a Barrel Roll!",
      @"The cake is a lie.",
	  @"Y tho?",

      @"6/10. Too much Coin. Not enough Block. -IGN",
      @"6/10. Too much Coin. Not enough Block. -IGN",
      @"6/10. Too much Coin. Not enough Block. -IGN",

	  @"My body is ready. 💪", //☝️

	  @"You laugh, you lose Coins!",

      //futurama
      @"Good news, everyone!",
      @"Now with flavor!",
      //@"Made you look!",
      //@"If you don't play it, someone else will!",
      //@"If this block's a-rockin', don't come a-tappin'",
      //@"[Cancel] [OK]",

      //@"One shall stand, one shall fall.",

      @"You are not prepared!",
      @"That's what she said!",
      //@"The more you know...",
      //@"Honey badger don't care!",

      @"Could there BE any more Coins?",

      //@"I choo-choo-choose you!",
      //@"Do you even lift bro?",

      @"You're gonna have a good time!",

      @"Will work for Coins!",

      @"The Coins miss you 😢. So come play!",


      //@"Knock knock...",


	  //taylor swift
	  @"Look what you made me do.",

      //zelda
      @"It's a secret to everybody.",
      @"Hey, listen!",

      @"Secret is in the tree at the dead-end.",
      @"There are secrets where fairies don't live.",
      @"Walk into the waterfall.",
      @"Eastmost penninsula is the secret.",
      @"There's a secret in the tip of the nose.",
      @"Meet the old man at the grave.",



      @"Oh! My car...",

      //@"notif: top 12 Coins that' can't even",

      @"You literally can't even!",

      @"Trololololololololololo!",

      @"Then I took an arrow in the knee.",
      @"Are we having fun yet?",

      //emojis

      //full house
      //@"How rude!",
      //@"Have mercy!",
      //@"Cut it out!"
      //@"✂️ 👈 👍",
      //@"Cut. It. Out! ✂️👈👍",
      //@"You got it dude!",

      //@"The dance of joy! 🎶🙌",

      //archer
      //@"Lana. Lana. Lana! Lanaaaa!! Danger zone.",
      //@"Danger zone!",
      @"Phrasing. Boom.",

      //NES
      //http://sydlexia.com/nesquotes1.htm
      @"Let me remove the eggplant curse!",
      //@"Ouch! What do you do?",

      //@"Her?",


        //secret
       //@"Can you find the secret Minus World?",
	  //upside down
      //http://www.fileformat.info/convert/text/upside-down.htm
      @"¿pʃɹoM snuıW ʇǝɹɔǝs ǝɥʇ puıɟ noʎ uɐↃ",
      @"¿pʃɹoM snuıW ʇǝɹɔǝs ǝɥʇ puıɟ noʎ uɐↃ",
      @"¿pʃɹoM snuıW ʇǝɹɔǝs ǝɥʇ puıɟ noʎ uɐↃ",
      @"¿pʃɹoM snuıW ʇǝɹɔǝs ǝɥʇ puıɟ noʎ uɐↃ",

	  //secret block
       //@"Can you find the secret Block?",
	  //upside down
      //http://www.fileformat.info/convert/text/upside-down.htm
      @"¿ʞɔoʃ𐐒 ʇǝɹɔǝs ǝɥʇ puıɟ noʎ uɐↃ",
      @"¿ʞɔoʃ𐐒 ʇǝɹɔǝs ǝɥʇ puıɟ noʎ uɐↃ",
      @"¿ʞɔoʃ𐐒 ʇǝɹɔǝs ǝɥʇ puıɟ noʎ uɐↃ",
      @"¿ʞɔoʃ𐐒 ʇǝɹɔǝs ǝɥʇ puıɟ noʎ uɐↃ",

    //sinistar
    @"Beware, I live!",
    //@"Run, coward!",
    //@"Run! Run! Run!",
    //@"Wroooaaarrrr!",
    //@"Beware, coward!",
    //@"I am Sinistar!",
    //@"I hunger!",
    //@"I hunger, coward!",


    //80s
    //@"Cut. It. Out.",
    //@"Homey Don't Play Dat.",
    //@"Not The Mama, Not The Mama!",
    //@"Did IIIIIII Do Thaaaaat?",
    //@"I've Fallen And I Can't Get Up.",
    //@"The Power Is YOURS!",
    @"Alllllllrighty then.",
    //@"Keep The Change, Ya Filthy Animal.",
    //@"It's Naht A Toomah.",
    //@"Wanna Hear The Most Annoying Sound In The World?",
    //@"Hold Onto Your Butts.",
    //@"There's No Crying In Baseball.",
    //@"Munch On Some Grindage",
    //@"You're Killin' Me, Smalls.",

    //ta, toucharcade
    @"So good it's dumb!",

    @"I'm sorry, Dave. I'm afraid I can't do that.",

      //smash tv
      @"BIG money! BIG prizes! I Love it!",
      @"I'd buy that for a dollar!",

      //@"You mad, bro?",

      //@"Coins detected in pocket.", //Berzerk

	  //"Another Visitor... stay a while.... staaaaaayyyyyyyyyyy forever!", //mission impossible

      ];


    //NSFW
    NSArray *extras2 = @[];
    if(!kAppDelegate.inReview && kAppDelegate.level >= 2) {
        extras2 =
        @[
          //@"Marry me!",
          //@"I've made a huge mistake...",

          @"Hallelujah, it's raining Coins!",
          @"You're missing out on lots of Coins! #fomo",
          //@"Be vewy vewy qwiet. I'm hunting Coins!",
          @"I am error.",
          @"A winner is you!",


          //game memes
          //@"Press X to die!",
          //@"Sanic, gotta go fast",
          //@"Half-Life 3 confirmed",
          //@"CoinBlock 3 confirmed",


          //@"?sedoc taehc", //cheat codes
          //@"?sedoc taehc", //cheat codes
          //@"?sedoc taehc", //cheat codes


          //pew
          //@"You have 1 new friend!",
          //@"Meet some friends of mine!",
          //@"So come on down to Coiny Block and meet some friends of mine.",

          @"98% can't do this.",

          @"100000% u will laff",

          @"BEST 👏 GAME 👏 2 0 1 8 🐔",

          //nintendo NES
          @"Now you're playing with Power!",
          @"Now you're knitting with Power!",

          @"It's a me, Coiny Block!",

         ];

    }

    NSArray *extras3 = @[];

    if([kHelpers isMonday]) {
        //case of the mondays
        //garfiend

        extras3 =
        @[
          @"Uh oh, sounds like someone has the case of the Mondays!",
          @"Uh oh, sounds like someone has the case of the Mondays!",
          @"Uh oh, sounds like someone has the case of the Mondays!",
          @"Uh oh, sounds like someone has the case of the Mondays!",
          @"Uh oh, sounds like someone has the case of the Mondays!",
          ];
    }
    else if([kHelpers isFriday]) {

    }

    //night, after 8pm
    NSArray *extras4 = @[];
    if([kHelpers isNight]) {
        extras4 = @[
                    @"What a horrible night to have a curse.",
                    @"What a horrible night to have a curse.",
                    @"What a horrible night to have a curse.",
                    @"What a horrible night to have a curse.",
                    ];
    }


    NSArray *merged = [messageArray arrayByAddingObjectsFromArray:extras];
    merged = [merged arrayByAddingObjectsFromArray:extras2];
    merged = [merged arrayByAddingObjectsFromArray:extras3];
    merged = [merged arrayByAddingObjectsFromArray:extras4];

    return merged;
}


+(NSString *)getRandomWorldName {

    BOOL random = NO;
    BOOL list = NO;
    BOOL generated = YES;

#if 0
    //exceptions
	int level = (int)kAppDelegate.level;


	//startswith
	//http://nounsstarting.com/places-that-start-with-b/
	/*
		"Canonball Canyon"
		"Bat Bayou", bay, badlands, basin,
		"Fire Fields"
		"Bullet Hell"
		"Boulder Basin"
		"Invader Island"
		"Asteroid Alley"

		//"Ninja Nook" //premium?
		//"Spike Spot", span, sprawl, spree
	*/


	switch(level)
	{

		case 5: //cheat fun
		{
			return  @"Bat Bayou";
		}
		break;
		case 10:
		{
			return  @"Canonball Canyon";
		}
		break;
		case 15:
		{
			return  @"Fire Fields";
		}
		break;

		case 20:
		{
			return  @"Bullet Hell";
		}
		break;

		case 25:
		{
			return  @"Boulder Basin";
		}
		break;

		case 30:
		{
			return  @"Invader Island";
		}

		case 35:
		{
			return  @"Asteroid Alley";
		}

		case 40:
		{
			if(premium && !inReview)
			{
				return  @"Turtle Trench";
			}
		}

		break;



		default:
		break;
	}
#endif

    if(random)  {
        NSMutableArray *first =
        [ @[
          //@"Special",
          @"Sunny",
          @"Pipe",
          //@"Grass",
          @"Water",
          @"Giant",
          @"Sky",
          @"Ice",
          @"Pipe",
          @"Dark",
          //@"Warp",
          @"Vanilla",
          @"Twin",
          @"Chocolate",
          @"Bumpy",
          @"Scary",
          @"Foggy",
          @"Northern",
          @"Southern",
          @"Eastern",
          @"Western",
          @"Lost",
          @"Hidden",
          @"Borean",
          @"Jade",
          @"Sky",
          @"Wet",
          //@"Water",
          //@"Sand,"
          ] mutableCopy];

        //remove dupliquates
        NSMutableArray *first2 = [NSMutableArray array];
        for (id obj in first) {
            if (![first2 containsObject:obj]) {
                [first2 addObject:obj];
            }
        }


        NSMutableArray *second =
        [ @[
            @"Valley",
            @"World",
            //@"Zone",
            @"Lands",
            @"Plains",
            //@"Dome",
            @"Bridges",
            @"Island",
            @"Isle",
            @"Desert",
            @"Forest",
            @"Planet",
            @"Glades",
            @"Hills",
            //@"Foothills",
            @"Marsh",
            @"Woods",
            @"Mountains",
            @"Pass",
            @"Fjord",
            @"Tundra",
            @"Bassin",
            //@"Landings",
            @"Peaks",
            @"Ridge",
            @"Jungle",
            @"Peninsula",
            @"Bay",
            @"Cave",
            @"Tundra",
            @"Swamp",

            ] mutableCopy];

        //remove dupliquates
        NSMutableArray *second2 = [NSMutableArray array];
        for (id obj in second) {
            if (![second2 containsObject:obj]) {
                [second2 addObject:obj];
            }
        }

#if 0
        if([kHelpers isDebug]) {
            //generate
            NSMutableArray *arrayUniques = [NSMutableArray array];
            NSMutableArray *arrayUniquesFirst = [NSMutableArray array];
            NSMutableArray *arrayUniquesSecond = [NSMutableArray array];

            //first hardcoded
            [arrayUniques addObject:@"\"Grass Zone\""];

            [arrayUniquesFirst addObject:@"Grass"];
            [arrayUniquesSecond addObject:@"Zone"];
            [arrayUniquesFirst addObject:@"Final"];
            [arrayUniquesSecond addObject:@"World"];

            double k=0;
            int maxArray = kLevelMax;
            while(k<100000 && (arrayUniques.count < maxArray)) {

                NSString *firstRandom = [first2 randomObject];
                NSString *secondRandom = [second2 randomObject];

                NSString *temp = [NSString stringWithFormat:@"\"%@ %@\"", firstRandom, secondRandom];
                //if (![arrayUniques containsObject:temp] && ![arrayUniquesFirst containsObject:firstRandom] && ![arrayUniquesSecond containsObject:secondRandom]) {
                if (![arrayUniques containsObject:temp]) {

                    [arrayUniques addObject:temp];
                    [arrayUniquesFirst addObject:firstRandom];
                    [arrayUniquesSecond addObject:secondRandom];
                }
                k++;
            }

            //last hardcoded
            [arrayUniques addObject:@"\"Final World?\""];
            //[arrayUniques addObject:@"\"Final World\""];
            //[arrayUniques addObject:@"\"The end?\""];
            //[arrayUniques addObject:@"Final Fortress"];


            arrayUniques = [[arrayUniques shuffledArray] mutableCopy];
            Log(@"world name generationdone");
            if([kHelpers isDebug])
                assert(0);
        }

#endif


        NSString *temp = [NSString stringWithFormat:@"%@ %@", [first2 randomObject], [second2 randomObject]];
        return temp;
    }
    else if(list) {
        //non random, manual
        NSArray *array = @[
                           @"test",
                           ];

        return [array randomObject];
    }

    else if(generated) {
        //generated

		//exceptions
        if(kAppDelegate.level == kLevelMax) //kLevelEnding?
        {
            Log(@"last level");
            return @"Nega-Brain Fortress"; //@"???"
        }

        NSArray *array = @[
                           @"Grass Zone",  //@"Tutorial",
                           @"Northern Jungle",
                           @"Scary Glades",
                           @"Wet Bridges",
                           @"Lost Mountains",
                           @"Vanilla Woods",
                           @"Bumpy Desert",
                           @"Western Desert",
                           @"Twin Peninsula",
                           @"Eastern Mountains",
                           @"Pipe Tundra",
                           @"Sky Peninsula",
						   //last?
                           @"Hidden Mountains",
                           @"Lost Peaks",
                           @"Sunny Fjord",
                           @"Borean World",
                           @"Foggy Glades",
                           @"Western Cave",
                           @"Foggy Woods",
                           @"Sunny Peaks",
                           @"Sunny Hills",
                           @"Hidden Planet",
                           @"Jade Valley",
                           @"Sky Bridges",
                           @"Chocolate Peninsula",
                           @"Sky Plains",
                           @"Water Bassin",
                           @"Borean Jungle",
                           @"Sky Forest",
                           @"Scary Planet",
                           @"Water Cave",
                           @"Sunny Planet",
                           @"Wet Pass",
                           @"Western Valley",
                           @"Jade Bay",
                           @"Hidden Cave",
                           @"Twin Fjord",
                           @"Water Fjord",
                           @"Western Peninsula",
                           @"Sky Glades",
                           @"Eastern Pass",
                           @"Northern Pass",
                           @"Northern Island",
                           @"Wet Planet",
                           @"Chocolate Jungle",
                           @"Giant Plains",
                           @"Sky Island",
                           @"Southern Glades",
                           @"Water Marsh",
                           @"Foggy Forest",
                           @"Western World",
                           @"Pipe Valley",
                           @"Lost Pass",
                           @"Jade Peninsula",
                           @"Giant Ridge",
                           @"Lost Tundra",
                           @"Twin Peaks",
                           @"Twin World",
                           @"Hidden Bay",
                           @"Sky Bassin",
                           @"Southern Forest",
                           @"Jade Plains",
                           @"Sky Lands",
                           @"Northern Bassin",
                           @"Pipe Forest",
                           @"Scary Pass",
                           @"Borean Cave",
                           @"Scary Plains",
                           @"Wet Desert",
                           @"Hidden Mountains",
                           @"Ice Bassin",
                           @"Northern Isle",
                           @"Northern Valley",
                           @"Giant Desert",
                           @"Lost Desert",
                           @"Twin Woods",
                           @"Lost Peninsula",
                           @"Sunny Valley",
                           @"Southern Pass",
                           @"Bumpy Planet",
                           @"Vanilla Bridges",
                           @"Chocolate Planet",
                           @"Sky Isle",
                           @"Wet Ridge", ///
                           @"Chocolate Ridge",
                           @"Ice Tundra",
                           @"Wet Bay",
                           @"Wet Valley",
                           @"Western Mountains",
                           @"Chocolate Tundra",
                           @"Giant Hills",
                           @"Scary Lands",
                           @"Western Forest",
                           @"Chocolate Mountains",
                           @"Western Glades",
                           @"Northern Forest",
                           @"Lost Bridges",
                           @"Eastern Plains",
                           @"Sky Valley",
                           @"Foggy Peninsula",
                           ];


        int index = (int)kAppDelegate.level -1;
        if(index <= 0)
            index = 0;
        if(index >= array.count) {
            return @"???";
        }

        return [array objectAtIndex:index];

        //return [array randomObject];
    }

    return nil;
}

+(NSString *)getRandomOKButton {

    //disabled
    return LOCALIZED(@"kStringOK");

    //return [CBSkinManager getRandomOKButton2];
}

+(NSString *)getRandomOKButton2 {

#if 1
    //disabled
    NSArray *messageArray =
    @[
      @"Cool!",
      @"Awesome!",
      @"Got it!",
      //@"Okey dokey!",
      //@"Sounds good!",
      @"Yay!",
      //@"Yup!",
      //@"Do it!",
      //@"Bam!",
      //@"Okay then!",
      //@"Yass!",
      //@"You betcha!",
      //@"A'ight!",
      //@"OK",
      @"Great!",
      @"Nice!",
      @"Oh yeah!",
      @"Wow!",
      ];

    NSString *temp = [messageArray randomObject];
    return temp;
#endif
}


+(float)getFireballTimerMult {
    float mult = 1.0f;

    mult -= (kAppDelegate.level * 0.01f);

    return mult;
}

+(float)getHeartHealTime
{   //seconds
    float time = kHeartHealTime;
    float mult = 1.0f; //[self getMultIndex];


    mult += kAppDelegate.level / 10.0f;

    time *= mult ;


    //test
    /*if([kHelpers isDebug]) {
        //time = 2.0;
        //time = 0.5f;
    }*/

    //seconds
    time *= 60;
    return time;
}

+(int)getRandomOdds:(int)index
{
    int odds = 0;

    int type = [self getBlockType:index];


    if(type == kCoinTypeCommon) {
        odds = 100;
    }
    else if(type == kCoinTypeUncommon) {
        odds = 50;
    }
    else if(type == kCoinTypeRare) {
        odds = 10;
    }
    else if(type == kCoinTypeEpic) {
        odds = 5;
    }
    else if(type == kCoinTypeLegendary) {
        odds = 1;
    }


    /*
    if(index == kCoinTypeDefault) {
        odds = 100;
    }
    else if(index == kCoinTypeMine) {
        odds = 100;
    }
    else if(index == kCoinTypeMetal) {
        odds = 100;
    }
    else if(index == kCoinTypeZelda) {
        odds = 30;
    }
    else if(index == kCoinTypeBitcoin) {
        odds = 30;
    }
    else if(index == kCoinTypeSonic) {
        odds = 30;
    }
    else if(index == kCoinTypeYoshi) {
        odds = 30;
    }
    else if(index == kCoinTypeFlat) {
        odds = 20;
    }
    else if(index == kCoinTypeGameboy) {
        odds = 10;
    }
    else if(index == kCoinTypeBrain) {
        odds = 0;
    }
    else if(index == kCoinTypeTA) {
        odds = 10;
    }
    else if(index == kCoinTypePew) {
        odds = 1;
    }
    else if(index == kCoinTypeMario) {
        odds = 0;
    }
    */


    /*
    else if(index == kCoinTypeMega) {
        odds = 100;
    }
    else if(index == kCoinTypeMac) {
        odds = 100;
    }


    else if(index == kCoinTypeMario) {
        odds = 100;
    }

    else if(index == kCoinTypeZoella) {
        odds = 100;
    }

    else if(index == kCoinTypeMontreal) {
        odds = 100;
    }

    else if(index == kCoinTypeNyan) {
        odds = 100;
    }

    else if(index == kCoinTypeEmoji) {
        odds = 100;
    }*/

    return odds;
}

+(NSString*)getBlockHashtag:(int)index {
    NSString *name = nil;

    if(index == kCoinTypeDefault) {
        //name = @"http://www.google.com/";
    }

    else if(index == kCoinTypeFlat) {
        //name = @"http://www.google.com/";
    }

    else if(index == kCoinTypeMega) {
        //name = @"http://www.google.com/";
    }

    else if(index == kCoinTypeMine) {
        //name = @"https://itunes.apple.com/ca/app/id479516143?mt=8";
    }

    else if(index == kCoinTypeMetal) {
        //name = @"https://itunes.apple.com/ca/app/id479516143?mt=8";
    }

    else if(index == kCoinTypeYoshi) {
        //name = @"http://www.google.com/";
    }

    else if(index == kCoinTypeSonic) {
        //name = @"http://www.google.com/";
    }

    else if(index == kCoinTypePew) {
        name = @"https://www.youtube.com/user/PewDiePie";
    }

    else if(index == kCoinTypeZelda) {
        //name = @"http://www.google.com/";
    }

    else if(index == kCoinTypeBitcoin) {
        //name = @"https://bitcoin.org/en/";
    }

    else if(index == kCoinTypeMac) {
        //name = @"http://www.google.com/";
    }

    else if(index == kCoinTypeFlap) {
        //name = @"http://flappybird.io/";
    }

    else if(index == kCoinTypeMario) {
        //name = @"http://www.google.com/";
    }

    else if(index == kCoinTypeGameboy) {
        //name = @"http://www.google.com/";
    }

    else if(index == kCoinTypeBrain) {
        //name = @"http://www.google.com/";
    }

    else if(index == kCoinTypeZoella) {
        name = @"https://www.youtube.com/user/zoella280390";
    }

    else if(index == kCoinTypeMontreal) {
        name = @"http://www.tourisme-montreal.org/";
    }


    else if(index == kCoinTypeTA) {
        name = @"http://www.toucharcade.com/";
    }


    else if(index == kCoinTypeNyan) {
        name = @"https://www.youtube.com/watch?v=QH2-TGUlwu4";
    }

    else {
        //default
        Log(@"getBlockHashtag: default");
        //name = @"";
    }


    //assert(name);
    return name;


}

+(NSString*)getBlockTwitterUser:(int)index {
    NSString *name = nil;

    if(index == kCoinTypeDefault) {
        //name = @"http://www.google.com/";
    }

    else if(index == kCoinTypeFlat) {
        //name = @"http://www.google.com/";
    }

    else if(index == kCoinTypeMega) {
        //name = @"http://www.google.com/";
    }

    else if(index == kCoinTypeMine) {
        //name = @"https://itunes.apple.com/ca/app/id479516143?mt=8";
        //name = @"https://minecraft.net/";
    }

    else if(index == kCoinTypeMetal) {
        //name = @"https://itunes.apple.com/ca/app/id479516143?mt=8";
        //name = @"https://minecraft.net/";
    }

    else if(index == kCoinTypeYoshi) {
        //name = @"http://www.google.com/";
    }

    else if(index == kCoinTypeSonic) {
        //name = @"http://www.google.com/";
    }

    else if(index == kCoinTypePew) {
        name = @"https://www.youtube.com/user/PewDiePie";
    }

    else if(index == kCoinTypeZelda) {
        //name = @"http://www.google.com/";
    }

    else if(index == kCoinTypeBitcoin) {
        //name = @"http://www.google.com/";
    }

    else if(index == kCoinTypeMac) {
        //name = @"http://www.google.com/";
    }

    else if(index == kCoinTypeFlap) {
        // name = @"http://flappybird.io/";
    }

    else if(index == kCoinTypeMario) {
        //name = @"http://www.google.com/";
    }

    else if(index == kCoinTypeGameboy) {
        //name = @"http://www.google.com/";
    }
    else if(index == kCoinTypeBrain) {
        //name = @"http://www.google.com/";
    }

    else if(index == kCoinTypeZoella) {
        name = @"https://www.youtube.com/user/zoella280390";
    }

    else if(index == kCoinTypeMontreal) {
        //name = @"http://www.google.com/";
    }


    else if(index == kCoinTypeTA) {
        name = @"http://www.toucharcade.com/";
    }


    else if(index == kCoinTypeNyan) {
        name = @"https://www.youtube.com/watch?v=QH2-TGUlwu4";
    }
    else {
        //default
        Log(@"getBlockTwitterUser: default");
        //name = @"";
    }

    //assert(name);
    return name;


}

+(NSString*)getBlockWebsite:(int)index {
    NSString *name = nil;

    if(index == kCoinTypeDefault) {
        //name = @"http://www.google.com/";
    }

    else if(index == kCoinTypeFlat) {
        //name = @"http://www.google.com/";
    }

    else if(index == kCoinTypeMega) {
        //name = @"http://www.google.com/";
    }

    else if(index == kCoinTypeMine) {
        //name = @"https://itunes.apple.com/ca/app/id479516143?mt=8";
    }

    else if(index == kCoinTypeMetal) {
        //name = @"https://itunes.apple.com/ca/app/id479516143?mt=8";
    }

    else if(index == kCoinTypeYoshi) {
        //name = @"http://www.google.com/";
    }

    else if(index == kCoinTypeSonic) {
        //name = @"http://www.google.com/";
    }

    else if(index == kCoinTypePew) {
        name = @"https://www.youtube.com/user/PewDiePie";
    }

    else if(index == kCoinTypeZelda) {
        //name = @"http://www.google.com/";
    }

    else if(index == kCoinTypeBitcoin) {
        //name = @"https://bitcoin.org/en/";
    }

    else if(index == kCoinTypeMac) {
        //name = @"http://www.google.com/";
    }

    else if(index == kCoinTypeFlap) {
        //name = @"http://flappybird.io/";
    }

    else if(index == kCoinTypeMario) {
        //name = @"http://www.google.com/";
    }

    else if(index == kCoinTypeGameboy) {
        //name = @"http://www.google.com/";
    }

    else if(index == kCoinTypeBrain) {
        //name = @"http://www.google.com/";
    }

    else if(index == kCoinTypeZoella) {
        name = @"https://www.youtube.com/user/zoella280390";
    }

    else if(index == kCoinTypeMontreal) {
        //name = @"http://www.google.com/";
    }


    else if(index == kCoinTypeTA) {
        name = @"http://www.toucharcade.com/";
    }


    else if(index == kCoinTypeNyan) {
        name = @"https://www.youtube.com/watch?v=QH2-TGUlwu4";
    }
    else {
        //default
        Log(@"getBlockWebsite: default");
        //name = @"";
    }


    //assert(name);
    return name;
}

+(NSString*)getBlockDescIndex:(int)index {
    NSString *name = nil; //@"-";

    //default
    //name = [NSString stringWithFormat:@"Skin %d", index+1];

    if(index == kCoinTypeDefault) {
        name = @"You gotta start somewhere."; //@"Default";
    }

    else if(index == kCoinTypeFlat) {
        name = @"Catchy app";
    }

    else if(index == kCoinTypeMega) {
        //name = @"Mega fun";
    }

    else if(index == kCoinTypeMine) {
        //name = @"Minecraft";
        name = @"Keep crafting";
    }

    else if(index == kCoinTypeMetal) {
        //name = @"Minecraft";
        name = @"Keep crafting";
    }

    else if(index == kCoinTypeYoshi) {
        name = @"Eggciting";
       // name = @"Eggstreme";
    }

    else if(index == kCoinTypeSonic) {
        //name = @"Boom";
    }

    else if(index == kCoinTypePew) {
        name = @"Brofist!";
        //name = @"Brofist! \nVerified, it just means i'm me.";
    }

    else if(index == kCoinTypeZelda) {
        //name = @"To the past";
        name = @"Legendary";
    }

    else if(index == kCoinTypeBitcoin) {
        //name = @"Open source P2P money";
        name = @"l337 h4x0r s|<1llz "; //Pwn

    }

    else if(index == kCoinTypeMac) {
        //name = @"Classic";
    }

    else if(index == kCoinTypeFlap) {
        name = @"Flap, flap, flap";
    }

    else if(index == kCoinTypeMario) {
        //name = @"Retro";
    }

    else if(index == kCoinTypeGameboy) {
        //name = @"Boy";
    }
    else if(index == kCoinTypeBrain) {
        //name = @"Boy";
    }

    else if(index == kCoinTypeZoella) {
        name = @"Beauty, Fashion & Lifestyle Blog.";
    }

    else if(index == kCoinTypeMontreal) {
        name = @"Proudly made in Montreal.";
    }

    else if(index == kCoinTypeTA) {
        //name = @"Awesome iOS gaming news site and podcast. Addictively polished.";
        name = @"Awesome iOS gaming news site and podcast. Also sometimes about cats and wrestling.";
    }

    else if(index == kCoinTypeNyan) {
        name = @"Meow meow meow meow meow...";
    }
    else if(index == kCoinTypeEmoji) {
        name = @":)  :P  ;)  =D";
        //( ͡° ͜ʖ ͡°)
    }
    else if(index == kCoinTypeEmoji) {
        name = @"Happy Valentine's Day!";
        //( ͡° ͜ʖ ͡°)
    }
    else {
        //default
        Log(@"getBLockDescIndex: default");
        //name = @"";
    }


    //assert(name);
    return name;

}

+(NSString*)getBlockDisplayNameIndex:(int)index {
    return [self getBlockDisplayNameIndex:index multiLine:NO];
}

+(NSString*)getBlockDisplayNameIndex:(int)index multiLine:(BOOL)multiline {

    NSString *name = nil;

    //default
    //name = [NSString stringWithFormat:@"Skin %d", index+1];
    name = @"???";

    if(index == kCoinTypeNone) {
        //nothing
    }

    else if(index == kCoinTypeDefault) {
        name = @"Newbie"; //@"Default";
    }

    else if(index == kCoinTypeFlat) {
        name = @"Catch up";
    }

    else if(index == kCoinTypeMega) {
        name = @"Platformer"; //name = @"Mega";
    }

    else if(index == kCoinTypeMine) {
        name = @"Miner";
    }

    else if(index == kCoinTypeMetal) {
        name = @"Metal";
    }

    else if(index == kCoinTypeYoshi) {
        name = @"Egg";
    }

    else if(index == kCoinTypeSonic) {
        name = @"Edgy"; //@"Sanic Hegehog"; //Sanic, gotta go fast
    }

    else if(index == kCoinTypePew) {
        name = @"PewDiePie"; //@"Pewds";
    }

    else if(index == kCoinTypeZelda) {
        name = @"Linked";
        //name = @"Helda";
        //name = @"Master";
    }

    else if(index == kCoinTypeBitcoin) {
        name = @"Hacker";
    }

    else if(index == kCoinTypeMac) {
        name = @"Classic";
    }

    else if(index == kCoinTypeFlap) {
        name = @"Flappy";
    }

    else if(index == kCoinTypeMario) {
        name = @"Super"; //@"Retro";
    }

    else if(index == kCoinTypeMario2) {
        name = @"Secret";
    }
    else if(index == kCoinTypeComingSoon) {
        name = @"More soon...";
    }
    else if(index == kCoinTypeGameboy) {
        name = @"2-bit"; //@"Oh Boy";
    }
    else if(index == kCoinTypeBrain) {
        name = @"Nega-Brain";
    }
    else if(index == kCoinTypeZoella) {
        name = @"Zoella";
    }

    else if(index == kCoinTypeMontreal) {
        name = @"Montreal";
    }

    else if(index == kCoinTypeTA) {
        if(multiline)
            name = @"Touch\nArcade";
        else
            name = @"TouchArcade";
    }

    else if(index == kCoinTypeNyan) {
        name = @"Nyan Cat";
    }

    else if(index == kCoinTypeEmoji) {
        name = @"Emoji";
    }

    else if(index == kCoinTypeValentine) {
        name = @"Valentine";
    }

    else if(index == kCoinTypePatrick) {
        name = @"Patrick";
    }
    
    else if(index == kCoinTypeSoccer) {
        name = @"Soccer";
    }
    
    else {
        //default
        Log(@"getBlockDisplayNameIndex: default");
        name = @"missing"; //@"Default";
        if([kHelpers isDebug])
            assert(0);
    }

    //assert(name);
    return name;
}


+(NSString*)getStartSoundName:(int)index {
    NSString *name = nil;

    //if(!kAppDelegate.inReview)
    //if(NO)
    {
        if(kAppDelegate.level == kLevelMax)
        {
            /*name = [@[
                          @"sinistar1.caf", //beware i live
                          @"sinistar2.caf", //run
                          @"sinistar3.caf", //rarrrrrr
                          @"sinistar4.caf", //i hunger
                          ] randomObject];*/

            name = @"sinistar3.caf"; //rarrrrrr

            return name;
        }
    }


    if(index == kCoinTypeDefault) {
        name = @"smb3_coin6.caf";
    }
    else if(index == kCoinTypeFlat) {
        name = @"coin_contra.caf";
    }
    else if(index == kCoinTypeMega) {
        name = @"coin_mega.caf";
    }

    else if(index == kCoinTypeMine) {
        name = @"coin_mine.caf";
    }

    else if(index == kCoinTypeMetal) {
        name = @"coin_metal.caf";
    }

    else if(index == kCoinTypeYoshi) {
        name = @"coin_yoshi.caf";

    }

    else if(index == kCoinTypeSonic) {
        name = @"coin_sonic.caf";
    }

    else if(index == kCoinTypePew) {
        name = [self getStarClickSoundNameIndex:index];
    }

    else if(index == kCoinTypeZelda) {
        name = @"coin_zelda.caf";

    }

    else if(index == kCoinTypeBitcoin) {
        name = @"starClickBitcoin.caf";
    }

    else if(index == kCoinTypeMac) {
        name = @"coin_wood.caf";

    }

    else if(index == kCoinTypeFlap) {
        name = @"coin_flap.caf";

    }

    else if(index == kCoinTypeMario) {
        name = @"smb3_coin.caf";
    }
    else if(index == kCoinTypeGameboy) {
        name = @"coin_gameboy.caf";
    }


    else if(index == kCoinTypeBrain) {

        //name = @"smb3_coin.caf";

        //if(!kAppDelegate.inReview)
        if(NO)
        {

            name = [@[@"sinistar1.caf", //beware i live
                      @"sinistar2.caf", //run
                      //@"sinistar3.caf", //rarrrrrr
                      //@"sinistar4.caf", //i hunger
                      ] randomObject];
        }
        else
        {
            //name = @"smb3_coin.caf";
            name = @"sinistar3.caf"; //rarrrrrr
        }
    }


    else if(index == kCoinTypeZoella) {
        name = [self getStarClickSoundNameIndex:index];

    }

    else if(index == kCoinTypeMontreal) {
        name = [self getStarClickSoundNameIndex:index];
    }
    else if(index == kCoinTypeTA) {
        name = @"coin_ta2.caf";
    }
    else if(index == kCoinTypeNyan) {
        name = @"coin_nyan.caf";
    }
    else if(index == kCoinTypeEmoji) {
        name = [self getStarClickSoundNameIndex:index];
    }
    else if(index == kCoinTypeValentine) {
        name = @"coin_valentine1.caf";
    }
    else if(index == kCoinTypePatrick) {
        name = @"smb3_coin6.caf";
    }
    else if(index == kCoinTypeSoccer) {
        
        //name = @"smb3_coin6.caf"; //default
        name = @"coin_soccer1.caf"; //soccer ball
    }
    
    else {
        //default
        Log(@"getStartSoundName: default");
        name = @"smb3_coin6.caf";
    }

    //assert(name);
    return name;

}

+(NSString*)getCoinSoundNameIndex:(int)index {
    return [self getCoinSoundNameIndex:index which:0];
}


+(NSString*)getCoinSoundNameIndex:(int)index which:(int)which {
    NSString *name = nil;

    if(index == kCoinTypeDefault) {
        if(which == 0)
            name = @"smb3_coin6.caf";
    }
    else if(index == kCoinTypeFlat) {
        if(which == 0)
            name = @"coin_contra.caf";
        else
            name = @"coin_contra2.caf";

    }
    else if(index == kCoinTypeMega) {
        if(which == 0)
            name = @"coin_mega.caf";
        else
            name = @"coin_mega2.caf";

    }

    else if(index == kCoinTypeMine) {
        if(which == 0)
            name = @"coin_mine.caf";
        else
            name = @"coin_mine2.caf";

    }

    else if(index == kCoinTypeMetal) {
        if(which == 0)
            name = @"coin_metal.caf";
        else
            name = @"coin_metal.caf";

    }

    else if(index == kCoinTypeYoshi) {
        if(which == 0)
            name = @"coin_yoshi.caf";
    }

    else if(index == kCoinTypeSonic) {
        if(which == 0)
            name = @"coin_sonic.caf";
    }

    else if(index == kCoinTypePew) {

        if(which == 0)
            name = @"coin_piew.caf";
        else if(which == 1)
            name = @"coin_piew2.caf";
        else
            name = @"coin_piew3.caf";
    }

    else if(index == kCoinTypeZelda) {
        if(which == 0)
            name = @"coin_zelda.caf";

    }

    else if(index == kCoinTypeBitcoin) {
        if(which == 0)
            name = @"coin_icarus.caf";
        else
            name = @"coin_icarus2.caf";

    }

    else if(index == kCoinTypeMac) {
        if(which == 0)
            name = @"coin_wood.caf";

    }

    else if(index == kCoinTypeFlap) {
        if(which == 0)
            name = @"coin_flap.caf";
        else
            name = @"coin_flap2.caf";
    }

    else if(index == kCoinTypeMario) {
        if(which == 0)
            name = @"smb3_coin.caf";
    }
    else if(index == kCoinTypeGameboy) {
        if(which == 0)
            name = @"coin_gameboy.caf";
    }
    else if(index == kCoinTypeBrain) {
        if(which == 0)
            name = @"smb3_coin6.caf";
    }

    else if(index == kCoinTypeZoella) {
        if(which == 0)
            name = @"coin_zoella.caf";
        else
            name = @"coin_zoella2.caf";

    }

    else if(index == kCoinTypeMontreal) {
        if(which == 0)
            name = @"coin_montreal.caf";
        else
            name = @"coin_montreal2.caf";

    }

    else if(index == kCoinTypeTA) {

        if(which == 0)
            name = @"coin_ta.caf";
        else
            name = @"coin_ta2.caf";

    }

    else if(index == kCoinTypeNyan) {
        if(which == 0)
            name = @"coin_nyan.caf";
        else
            name = @"coin_nyan2.caf";

    }

    else if(index == kCoinTypeEmoji) {
        name = @"coin_ta.caf";
    }
    else if(index == kCoinTypeValentine) {

        if(which == 0)
            name = @"coin_valentine1.caf";
        else
            name = @"coin_valentine2.caf";
    }

    else if(index == kCoinTypePatrick) {
        name = @"smb3_coin6.caf";
    }
    
    else if(index == kCoinTypeSoccer) {
        
        if(which == 0)
            name = @"smb3_coin6.caf";
        else
            name = @"coin_soccer1.caf";

    }
    
    else {
        //default
        Log(@"getCoinSoundNameIndex: default");
        if(which == 0)
            name = @"smb3_coin6.caf";
    }

    //assert(name);
    return name;
}

+(NSString*)getFireClickSoundName:(int)which{

    return [self getFireClickSoundNameIndex:(int)[kAppDelegate getSkin] which:which];
}


+(int)getSkinIAPIndex:(NSString*)name
{
    int index = kCoinTypeNone;

    for(int i=0;i<kNumSkins;i++)
    {
        if([name isEqualToString:[self getSkinIAP:i]])
        {
            index = i;
            break;
        }
    }

    return index;
}

+(NSString*)getSkinIAP:(int)index;
{
    NSString *name = nil;

    if(index == kCoinTypeDefault) {
        name = nil;
    }
    else if(index == kCoinTypeMine) {
        name = kIAP_SkinMiner;
    }
    else if(index == kCoinTypeYoshi) {
        name = kIAP_SkinEgg;
    }
    else if(index == kCoinTypeSonic) {
        name = kIAP_SkinEdgy;
    }
    else if(index == kCoinTypePew) {
        name =kIAP_SkinPewDiePie;
    }
    else if(index == kCoinTypeZelda) {
        name = kIAP_SkinLinked;
    }
    else if(index == kCoinTypeBitcoin) {
        name = kIAP_SkinHacker;
    }
    else if(index == kCoinTypeFlap) {
        name = kIAP_SkinFlappy;
    }
    else if(index == kCoinTypeGameboy) {
        name = kIAP_SkinOhBoy;
    }
    else if(index == kCoinTypeBrain) {
        name = nil;
    }
    else if(index == kCoinTypeTA) {
        name = kIAP_SkinTouchArcade;
    }
    else if(index == kCoinTypeEmoji) {
        name = kIAP_SkinEmoji;
    }
    else if(index == kCoinTypeValentine) {
        name = nil;
    }
    else if(index == kCoinTypePatrick) {
        name = nil;
    }
    else if(index == kCoinTypeSoccer) {
        name = nil;
    }
    else if(index == kCoinTypeMario) {
        name = nil; //vip
    }


    //missing
    else if(index == kCoinTypeNyan) {
        name = nil;
    }
    else if(index == kCoinTypeZoella) {
        name = nil;
    }
    else if(index == kCoinTypeMontreal) {
        name = nil;
    }
    else if(index == kCoinTypeMac) {
        name = nil;
    }
    else if(index == kCoinTypeMetal) {
        name = nil;
    }

    else if(index == kCoinTypeFlat) {
        name = nil;
    }
    else if(index == kCoinTypeMega) {
        name = nil;
    }
    else if(index == kCoinTypeCandy) {
        name = nil;
    }
    else if(index == kCoinTypeXmas) {
        name = nil;
    }
    else if(index == kCoinTypeFarm) {
        name = nil;
    }
    else if(index == kCoinTypeCoookie) {
        name = nil;
    }
    else if(index == kCoinType80s) {
        name = nil;
    }
    else if (index == kCoinTypeLaundro) {
        name = nil;
    }
    else {
        Log(@"getSkinIAP invalid");
        //assert(0);
    }


    //assert(name);
    return name;
}

+(CGFloat)getSkinWeakspotOffset:(int)index
{
    CGFloat offset = 90.0f; //100.0f

    if(index == kCoinTypeDefault) {
    }
    else if(index == kCoinTypeFlat) {
    }
    else if(index == kCoinTypeMega) {
    }
    else if(index == kCoinTypeMine) {
    }
    else if(index == kCoinTypeMetal) {
    }
    else if(index == kCoinTypeYoshi) {
    }
    else if(index == kCoinTypeSonic) {
    }
    else if(index == kCoinTypePew) {
    }
    else if(index == kCoinTypeZelda) {
    }
    else if(index == kCoinTypeBitcoin) {
    }
    else if(index == kCoinTypeMac) {
    }
    else if(index == kCoinTypeFlap) {
    }
    else if(index == kCoinTypeMario) {
    }
    else if(index == kCoinTypeMario2) {
    }
    else if(index == kCoinTypeComingSoon) {
    }
    else if(index == kCoinTypeGameboy) {
    }
    else if(index == kCoinTypeBrain) {
       	offset = 80;
    }
    else if(index == kCoinTypeZoella) {
    }
    else if(index == kCoinTypeMontreal) {
    }
    else if(index == kCoinTypeTA) {
    }
    else if(index == kCoinTypeNyan) {
    }
    else if(index == kCoinTypeEmoji) {
        offset = 80;
    }
    else if(index == kCoinTypeValentine) {
        offset = 80;
    }
    else if(index == kCoinTypeSoccer) {
        offset = 80;
    }
    //missing
    else if(index == kCoinTypeCandy) {
    }
    else if(index == kCoinTypeXmas) {
    }
    else if(index == kCoinTypeFarm) {
    }
    else if(index == kCoinTypeCoookie) {
    }
    else if(index == kCoinType80s) {
    }
    else if (index == kCoinTypeLaundro) {
    }
    else {
        Log(@"getSkinKey invalid");
        if([kHelpers isDebug])
            assert(0);
    }

    if([kHelpers isIphone4Size]) {
        //smaller
        offset /= 2;
    }

    //assert(name);
    return offset;
}

+(NSString*)getSkinKey:(int)index
{
    NSString *name = nil;


    if(index == kCoinTypeDefault) {
        name = @"kCoinTypeDefault";
    }
    else if(index == kCoinTypeFlat) {
        name = @"kCoinTypeFlat";
    }
    else if(index == kCoinTypeMega) {
        name = @"kCoinTypeMega";
    }
    else if(index == kCoinTypeMine) {
        name = @"kCoinTypeMine";
    }
    else if(index == kCoinTypeMetal) {
        name = @"kCoinTypeMine";
    }
    else if(index == kCoinTypeYoshi) {
        name = @"kCoinTypeYoshi";
    }
    else if(index == kCoinTypeSonic) {
        name = @"kCoinTypeSonic";
    }
    else if(index == kCoinTypePew) {
        name = @"kCoinTypePew";
    }
    else if(index == kCoinTypeZelda) {
        name = @"kCoinTypeZelda";
    }
    else if(index == kCoinTypeBitcoin) {
        name = @"kCoinTypeBitcoin";
    }
    else if(index == kCoinTypeMac) {
        name = @"kCoinTypeMac";
    }
    else if(index == kCoinTypeFlap) {
        name = @"kCoinTypeFlap";
    }
    else if(index == kCoinTypeMario) {
        name = @"kCoinTypeMario";
    }
    else if(index == kCoinTypeMario2) {
        name = @"kCoinTypeMario2";
    }
    else if(index == kCoinTypeComingSoon) {
        name = @"kCoinTypeComing";
    }
    else if(index == kCoinTypeGameboy) {
        name = @"kCoinTypeGameboy";
    }
    else if(index == kCoinTypeBrain) {
        name = @"kCoinTypeBrain";
    }
    else if(index == kCoinTypeZoella) {
        name = @"kCoinTypeZoella";
    }
    else if(index == kCoinTypeMontreal) {
        name = @"kCoinTypeMontreal";
    }
    else if(index == kCoinTypeTA) {
        name = @"kCoinTypeTA";
    }
    else if(index == kCoinTypeNyan) {
        name = @"kCoinTypeNyan";
    }
    else if(index == kCoinTypeEmoji) {
        name = @"kCoinTypeEmoji";
    }
    else if(index == kCoinTypeValentine) {
        name = @"kCoinTypeValentine";
    }
    else if(index == kCoinTypePatrick) {
        name = @"kCoinTypePatrick";
    }
    else if(index == kCoinTypeSoccer) {
        name = @"kCoinTypeSoccer";
    }
    //missing
    else if(index == kCoinTypeCandy) {
        name = @"kCoinTypeCandy";
    }
    else if(index == kCoinTypeXmas) {
        name = @"kCoinTypeXmas";
    }
    else if(index == kCoinTypeFarm) {
        name = @"kCoinTypeFarm";
    }
    else if(index == kCoinTypeCoookie) {
        name = @"kCoinTypeCoookie";
    }
    else if(index == kCoinType80s) {
        name = @"kCoinType80s";
    }
    else if (index == kCoinTypeLaundro) {
        name = @"kCoinTypeLaundro";
    }
    else {
        Log(@"getSkinKey invalid");
        if([kHelpers isDebug])
            assert(0);
    }


    //assert(name);
    return name;
}


+(BOOL)isSkinPremium:(int)index{

    if(index == kCoinTypeDefault) {
        return NO;
    }
    else if(index == kCoinTypeFlat) {
        return NO;
    }
    else if(index == kCoinTypeMega) {
        return NO;
    }
    else if(index == kCoinTypeMine) {
        return NO;
    }
    else if(index == kCoinTypeMetal) {
        return NO;
    }
    else if(index == kCoinTypeYoshi) {
        return NO;
    }
    else if(index == kCoinTypeSonic) {
        return NO;
    }
    else if(index == kCoinTypePew) {
        return NO;
    }
    else if(index == kCoinTypeZelda) {
        return NO;
    }
    else if(index == kCoinTypeBitcoin) {
        return NO;
    }
    else if(index == kCoinTypeMac) {
        return NO;
    }
    else if(index == kCoinTypeFlap) {
        return NO;
    }
    else if(index == kCoinTypeMario) {
        return YES; //!
    }
    else if(index == kCoinTypeGameboy) {
        return NO;
    }
    else if(index == kCoinTypeBrain) {
        return NO;
    }
    else if(index == kCoinTypeZoella) {
        return NO;
    }
    else if(index == kCoinTypeMontreal) {
        return NO;
    }
    else if(index == kCoinTypeTA) {
        return NO;
    }
    else if(index == kCoinTypeNyan) {
        return NO;
    }
    else if(index == kCoinTypeEmoji) {
        return NO;
    }
    else if(index == kCoinTypeValentine) {
        return NO;
    }
    else if(index == kCoinTypePatrick) {
        return NO;
    }
    else if(index == kCoinTypeSoccer) {
        return NO;
    }
    //missing
    else if(index == kCoinTypeCandy) {
        return NO;
    }
    else if(index == kCoinTypeXmas) {
        return NO;
    }
    else if(index == kCoinTypeFarm) {
        return NO;
    }
    else if(index == kCoinTypeCoookie) {
        return NO;
    }
    else if(index == kCoinType80s) {
        return NO;
    }
    else if (index == kCoinTypeLaundro) {
        return NO;
    }
    else {
        Log(@"isSkinPremium invalid");
        if([kHelpers isDebug])
            assert(0);
        return NO;
    }
}


+(NSString*)getFireClickSoundNameIndex:(int)index which:(int)which {
    NSString *name = nil;


    if(index == kCoinTypeDefault) {
        name = @"WilhelmScream.caf";

    }
    else if(index == kCoinTypeFlat) {
        name = @"WilhelmScream.caf";

    }
    else if(index == kCoinTypeMega) {
        name = @"wrong_mega.caf";

    }

    else if(index == kCoinTypeMine) {
        name = @"wrong_mine.caf";

    }
    else if(index == kCoinTypeMetal) {
        name = @"wrong_mine.caf";

    }

    else if(index == kCoinTypeYoshi) {
        name = @"WilhelmScream.caf";

    }

    else if(index == kCoinTypeSonic) {
        name = @"wrong_sonic.caf";

    }

    else if(index == kCoinTypePew) {

        if(which == 0)
            name = @"wrong_pew.caf";
        else
            name = @"wrong_pew2.caf";

    }

    else if(index == kCoinTypeZelda) {
        name = @"WilhelmScream.caf";

    }

    else if(index == kCoinTypeBitcoin) {
        name = @"wrong_bitcoin.caf";

    }

    else if(index == kCoinTypeMac) {
        name = @"WilhelmScream.caf";
    }

    else if(index == kCoinTypeFlap) {
        name = @"wrong_flappy.caf";
    }

    else if(index == kCoinTypeMario) {
        name = @"WilhelmScream.caf";

    }

    else if(index == kCoinTypeGameboy) {
        name = @"WilhelmScream.caf";

    }

    else if(index == kCoinTypeBrain) {
        name = @"WilhelmScream.caf";

    }

    else if(index == kCoinTypeZoella) {
        name = @"wrong_zoella.caf";

    }

    else if(index == kCoinTypeMontreal) {
        name = @"wrong_montreal.caf";

    }

    else if(index == kCoinTypeTA) {
        name = @"wrong_ta.caf";

    }

    else if(index == kCoinTypeNyan) {
        name = @"wrong_nyan.caf";

    }
    else if(index == kCoinTypeEmoji) {
        name = @"WilhelmScream.caf";
    }
    else if(index == kCoinTypeValentine) {
        name = @"wrong_valentine.caf";
    }
    else if(index == kCoinTypePatrick) {
        name = @"WilhelmScream.caf";
    }
    else if(index == kCoinTypeSoccer) {
        name = @"WilhelmScream.caf";
    }
    else {
        //default
        Log(@"getFireCLickSoundNameIndex: default");
        name = @"WilhelmScream.caf";
    }



    //assert(name);
    return name;
}

+(NSString*)getStarClickSoundName {
    return [self getStarClickSoundNameIndex:(int)[kAppDelegate getSkin]];
}

+(NSString*)getStarClickSoundNameIndex:(int)index {
    NSString *name = nil; //@"starClick3.caf";

    if(index == kCoinTypeDefault) {
        //name = @"starClick3.caf";

    }
    else if(index == kCoinTypeFlat) {
        //name = @"starClick3.caf";

    }
    else if(index == kCoinTypeMega) {
        //name = @"starClick3.caf";

    }

    else if(index == kCoinTypeMine) {
        //name = @"starClickMine.caf";
        //name = @"starClick3.caf";
    }

    else if(index == kCoinTypeMetal) {
        //name = @"starClickMine.caf";
        //name = @"starClick3.caf";
    }

    else if(index == kCoinTypeYoshi) {
        //name = @"starClick3.caf";

    }

    else if(index == kCoinTypeSonic) {
        //name = @"starClick3.caf";

    }

    else if(index == kCoinTypePew) {

        name = @"starClickPew.caf";
    }

    else if(index == kCoinTypeZelda) {
        //name = @"starClick3.caf";

    }

    else if(index == kCoinTypeBitcoin) {
        name = @"starClickBitcoin.caf";

    }

    else if(index == kCoinTypeMac) {
        //name = @"starClick3.caf";
    }

    else if(index == kCoinTypeFlap) {
        //name = @"starClick3.caf";
    }

    else if(index == kCoinTypeMario) {
        //name = @"starClick3.caf";

    }

    else if(index == kCoinTypeGameboy) {
        //name = @"starClick3.caf";

    }

    else if(index == kCoinTypeBrain) {
        //name = @"starClick3.caf";

    }

    else if(index == kCoinTypeZoella) {
        name = @"starClickZoella.caf";

    }

    else if(index == kCoinTypeMontreal) {
        name = @"starClickMontreal.caf";

    }

    else if(index == kCoinTypeTA) {
        name = @"starClickTa.caf";

    }

    else if(index == kCoinTypeNyan) {
        //name = @"starClick3.caf";

    }
    else if(index == kCoinTypeEmoji) {
        name = @"starEmoji.caf";
    }
    else if(index == kCoinTypeValentine) {
        name = @"starClickValentine.caf";
    }
    else if(index == kCoinTypePatrick) {
        //
    }
    else if(index == kCoinTypeSoccer) {
        //
    }
    else {
        //default
        Log(@"getStarClickSoundNameIndex: default");
        //name = @"starClick3.caf";
    }

    //assert(name);
    return name;
}


+(NSString*)getMusicName {

    NSString *name = nil;

    name = [self getMusicNameIndex:(int)[kAppDelegate getSkin]];
    //assert(name);
    return name;
}



+(NSString*)getLevelupMusicName{

    NSString *name = kMusicNameLevelup;

    int index = (int)[kAppDelegate getSkin];

    if(index == kCoinTypeDefault) {
    }

    else if(index == kCoinTypeFlat) {
    }

    else if(index == kCoinTypeMega) {
    }

    else if(index == kCoinTypeMine) {
    }
    else if(index == kCoinTypeMetal) {
    }

    else if(index == kCoinTypeYoshi) {
    }

    else if(index == kCoinTypeSonic) {
    }

    else if(index == kCoinTypePew) {
        name = @"musicLevelupPew.mp3";
    }

    else if(index == kCoinTypeZelda) {
    }

    else if(index == kCoinTypeBitcoin) {
    }

    else if(index == kCoinTypeMac) {
    }

    else if(index == kCoinTypeFlap) {
    }

    else if(index == kCoinTypeMario) {
    }

    else if(index == kCoinTypeGameboy) {
    }

    else if(index == kCoinTypeBrain) {
    }

    else if(index == kCoinTypeZoella) {
    }

    else if(index == kCoinTypeMontreal) {
    }
    else if(index == kCoinTypeTA) {
    }

    else if(index == kCoinTypeNyan) {
    }
    else {
        //default
        Log(@"getLevelUpMusicName: default");
    }


    //assert(name);
    return name;

}

+(NSString*)getMusicNameIndex:(int)index {

    NSString *name = kMusicNameDefault; //default


    if(index == kCoinTypeDefault) {
    }

    else if(index == kCoinTypeFlat) {
    }

    else if(index == kCoinTypeMega) {
    }

    else if(index == kCoinTypeMine) {
    }

    else if(index == kCoinTypeMetal) {
    }

    else if(index == kCoinTypeYoshi) {
    }

    else if(index == kCoinTypeSonic) {
    }

    else if(index == kCoinTypePew) {
        name = @"musicPewdie.mp3";
    }

    else if(index == kCoinTypeZelda) {
    }

    else if(index == kCoinTypeBitcoin) {
        name = @"musicBitcoin.mp3";
    }

    else if(index == kCoinTypeMac) {
    }

    else if(index == kCoinTypeFlap) {
    }

    else if(index == kCoinTypeMario) {
    }

    else if(index == kCoinTypeBrain) {
        //name = kMusicNameCastle; //only based on level
    }

    else if(index == kCoinTypeGameboy) {
    }

    else if(index == kCoinTypeBrain) {
    }

    else if(index == kCoinTypeZoella) {
        name = @"musicZoella.mp3";
    }

    else if(index == kCoinTypeMontreal) {
        name = @"musicMontreal.mp3";
    }
    else if(index == kCoinTypeTA) {

        //NSArray *array = @[@"musicTa.mp3", @"musicTa2.mp3"];
        NSArray *array = @[@"musicTa.mp3"];
        name = [array randomObject];
    }

    else if(index == kCoinTypeNyan) {
        name = @"musicNyan.mp3";
    }
    else {
        //default
        Log(@"getMusicNameIndex: default");
    }

    //assert(name);
    return name;

}

+(UIColor*)getMessageColor {

    //int index = (int)[kAppDelegate getSkin];

    //UIColor *color = [UIColor yellowColor]; //default
    UIColor *color = [UIColor colorWithHex:0xfdfd51]; //default, yellow

    //disabled
    return color;

}

+(UIColor*)getMessageOuchColor {

    //int index = (int)[kAppDelegate getSkin];

    //UIColor *color = [UIColor redColor]; //default
    UIColor *color = [UIColor colorWithHex:0xd50404];

    //disabled
    return color;

}

+(NSInteger)getWorldTime {

    //return 0;

	NSInteger time = kWorldTime; //default
    //return time;

	//60sec for each level
	int level = (int)kAppDelegate.level - 1;
	if(level < 0)
		level = 0;

	time += (level * kWorldTimePerLevel);

	return time;
}



//coinname

+(NSString*)getCoinImageName {
    return [self getCoinImageName:YES];
}

+(NSString*)getCoinImageName:(BOOL)random{

    NSString *name = nil;

    name = [self getCoinImageNameIndex:(int)[kAppDelegate getSkin] random:random];
    //assert(name);
    return name;
}

+(NSString*)getCoinImageNameIndex:(int)index random:(BOOL)random{


    NSString *name = nil;
    NSArray *array= nil;

    if(index == kCoinTypeDefault) {

        array = @[
                  @"coin3", //coin2
                  @"coin3", //coin2
                  @"coin3", //coin2

                  @"coin4", //agdq 1
                  @"coin5", //agdq 2

                  ];
    }

    else if(index == kCoinTypeFlat) {

        array = @[
                  @"coinContra",
                  @"coinContra2",
                  @"coinContra3",
                  ];

    }

    else if(index == kCoinTypeMega) {

        array = @[

            @"coinMega", //mega big
            @"coinMega2", //mega small
            @"coinMega3", //contra
            @"coinMega5", //wanna
            @"coinMega4", //coin metal slug
            ];
    }

    else if(index == kCoinTypeMine) {

        array = @[

            @"coinMine",
            @"coinMine2",
            @"coinMine3",
            @"coinMine4",
            ];


    }
    else if(index == kCoinTypeMetal) {

        array = @[

            @"coinMine",
            @"coinMine2",
            @"coinMine3",
            @"coinMine4",
            ];


    }

    else if(index == kCoinTypeYoshi) {

        array = @[

            @"coinYoshi",
            @"coinYoshi2",
            @"coinYoshi3",
            @"coinYoshi4",
            ];

    }

    else if(index == kCoinTypeSonic) {

        array = @[

            @"coinSonic2",
            @"coinSonic",
            ];


    }

    else if(index == kCoinTypePew) {

        array = @[

            @"coinPoo",

        //dog
            @"coinPiew2",
            @"coinPiew2",

        //felix
            @"coinPiew3",
            @"coinPiew3",

        //purple
            @"coinPiew4",
            @"coinPiew4",


        //duck
            @"coinPiew5",
            @"coinPiew5",

        //danny
            @"coinPiew6",
            @"coinPiew6",

        //zuck
            @"coinPiew10",

        //youtube
            @"coinPiew7",
            @"coinPiew7",


        //salad
            @"coinPiew8",
            @"coinPiew8",


        //glasses
            @"coinPiew9",
            @"coinPiew9",

        //flag
            @"coinPiew11",
            @"coinPiew11",

            @"coinPiew", //face
            ];

    }

    else if(index == kCoinTypeZelda) {

        array = @[


            @"coinZelda1", //green rupee
            @"coinZelda1", //green rupee
            @"coinZelda1", //green rupee
            @"coinZelda1", //green rupee
            @"coinZelda1", //green rupee

            @"coinZelda3", //orange ruby
            @"coinZelda3", //orange ruby
            @"coinZelda3", //orange ruby
            @"coinZelda3", //orange ruby


            @"coinZelda2", //blue rupee
            @"coinZelda2", //blue rupee
            @"coinZelda2", //blue rupee

            @"coinZelda4", //red ruby
            @"coinZelda4", //red ruby

            @"coinZelda5", //fairy

            ];

    }

    else if(index == kCoinTypeBitcoin) {

        array = @[

                  @"coinIcarus", //bitcoin orange
                  @"coinIcarus", //bitcoin orange
                  @"coinIcarus", //bitcoin orange

            @"coinIcarus3", //bitcoin grey", litecoin?
            @"coinIcarus2", //spinner
            @"coinIcarus4", //black arrow
            @"coinIcarus5", //wifi
            @"coinIcarus6", //CD macos
            @"coinIcarus7", //floppy
            @"coinIcarus8", //ether
            @"coinIcarus9", //defcon skull
            @"coinIcarus10", //netscape
            @"coinIcarus11", //ripple
            ];
    }

    else if(index == kCoinTypeMac) {

        array = @[

            @"coinWood",
            @"coinWood2",

            ];


    }

    else if(index == kCoinTypeFlap) {

        array = @[

            @"coinFlap", //bird
            @"coinFlap3", //coin copter
            @"coinFlap4", //copter
            @"coinFlap2", //coin
            ];

    }

    else if(index == kCoinTypeMario) {

        array = @[

            @"coin1Pink", //mario pink
            @"coinPink2", //mario turquoise
            @"coin1", //mario regular
            ];

    }

    else if(index == kCoinTypeGameboy) {

        array = @[
            @"coinGameboy2",
            @"coinGameboy",
            ];

    }

    else if(index == kCoinTypeBrain) {

        array = @[

            @"coin1Pink", //mario pink
            @"coinPink2", //mario turquoise
            @"coin1", //mario regular

            ];

    }

    else if(index == kCoinTypeZoella) {

        array = @[

            @"coinZoella2",
            @"coinZoella3",
            @"coinZoella", //pink
            ];


    }

    else if(index == kCoinTypeMontreal) {

        array = @[

            @"coinMontreal", //logo
        //    @"coinMontreal7", //bagel
            @"coinMontreal2", //puck
            @"coinMontreal4", //ubi
            @"coinMontreal5", //execution
        //    @"coinMontreal6", //bt
            @"coinMontreal8", //igda
            @"coinMontreal9", //leaf
        //    @"coinMontreal3", //tonie

            ];



    }
    else if(index == kCoinTypeTA) {

        array = @[

            @"coinTA2", //face eli
            @"coinTA3", //cracker
            @"coinTA4", //face jared
            @"coinTA6", //carter face
            @"coinTA7", //discord
            //@"coinTA5", //mikey coin
            @"coinTA5", //eli dog steve
            @"coinTA", //logo
            ];


		//patreon", discord? //replace cracker
		//clow possee
		//mr meeseeks

    }
    else if(index == kCoinTypeNyan) {

        array = @[
            @"coinNyan2", //rainbow
            @"coinNyan3", //doge
        //            @"coinNyan4", //rage
            @"coinNyan5", //cheeze
            @"coinNyan", //star
            ];

    }
    else if(index == kCoinTypeValentine) {

        array = @[

                  //@"coinZoella2",
                  @"coinZoella3", //kiss
                  @"coinZoella", //pink
                  @"coinEmoji11", //emoji heart eyes
                  ];

    }

    else if(index == kCoinTypePatrick) {
        
        array = @[
                  
                  @"coinPatrick1",
                  @"coinPatrick2",
                  @"coinPatrick3",
                  ];
    }
    
    else if(index == kCoinTypeSoccer) {
        
        //default
        array = @[
                  @"coin3", //coin2
                  @"coin3", //coin2
                  @"coin3", //coin2
                  
                  @"coin4", //agdq 1
                  @"coin5", //agdq 2
                  
                  @"coinSoccer1",
                  @"coinSoccer1",
                  @"coinSoccer1",
                  @"coinSoccer1",                  
                  ];
    }
    

    else if(index == kCoinTypeEmoji) {

        //if(kAppDelegate.inReview) {
        if(YES) {

            //apple approved
            array = @[
                      //@"block21Frame1_2",
                      @"coinEmojiSafe1", //tongue
                      @"coinEmojiSafe3", //sunglasses

                      @"coinEmoji2", //poo
                      //@"coinEmoji3", //sunglasses
                      @"coinEmoji4", //taco
                      //@"coinEmoji5", //lol cry
                      //@"coinEmoji6", //kiss
                      //@"coinEmoji7", //wine
                      @"coinEmoji8", //facebook
                      @"coinEmoji9", //twitter
                      @"coinEmoji10", //text bubble
                      //@"coinEmoji11", //heart eyes

                      ];

        }
        else
        {
            //original emoji
            array = @[
                      @"coinEmoji1", //tongue

                      @"coinEmoji2", //poo
                      @"coinEmoji3", //sunglasses
                      @"coinEmoji4", //taco
                      @"coinEmoji5", //lol cry
                      @"coinEmoji6", //kiss
                      //@"coinEmoji7", //wine
                      @"coinEmoji8", //facebook
                      @"coinEmoji9", //twitter
                      @"coinEmoji10", //text bubble
                      @"coinEmoji11", //heart eyes

                      //            @"coinZoella2",
                      //            @"coinZoella3",
                      //@"coinZoella", //pink
                      //@"coinEmoji12", //bloody
                      ];
        }




    }


    else {

        array = @[
                  @"coin3", //coin2
                  ];

        //default
        Log(@"getCoinImageNameIndexRandom: default");

    }

    if(random)
        name = [array randomObject];
    else
        name = [array firstObject];


    assert(name);
    return name;

}


+(NSString*)getCoinBarImageName{

    int index = (int)[kAppDelegate getSkin];
    NSString *name = nil;


    if(index == kCoinTypeDefault) {
        name = @"coin3"; //coin2
    }

    else if(index == kCoinTypeFlat) {

        name = @"coinContra3";
    }

    else if(index == kCoinTypeMega) {

        name = @"coinMega";
    }

    else if(index == kCoinTypeMine) {
        name = @"coinMine2";
    }

    else if(index == kCoinTypeMetal) {
        name = @"coinMine2";
    }

    else if(index == kCoinTypeYoshi) {
        name = @"coinYoshi";
    }

    else if(index == kCoinTypeSonic) {

        name = @"coinSonic";
    }

    else if(index == kCoinTypePew) {

        name = @"coinPiew";

    }

    else if(index == kCoinTypeZelda) {
        //name = @"coinZelda"; //multi
        name = @"coinZelda1"; //green
        //name = @"coinZelda2"; //blue
        //name = @"coinZelda3"; //orange
        //name = @"coinZelda4"; //red
    }

    else if(index == kCoinTypeBitcoin) {
        name = @"coinIcarus";

    }

    else if(index == kCoinTypeMac) {
        name = @"coinWood";

    }

    else if(index == kCoinTypeFlap) {
        name = @"coinFlap";
    }

    else if(index == kCoinTypeMario) {
        name = @"coin1";
    }

    else if(index == kCoinTypeGameboy) {
        name = @"coinGameboy";
    }

    else if(index == kCoinTypeBrain) {
        name = @"coin1";
    }


    else if(index == kCoinTypeZoella) {
        name = @"coinZoella";
    }

    else if(index == kCoinTypeMontreal) {

        //name = @"coinMontreal3"; //toonie
        name = @"coinMontreal9"; //leaf
    }
    else if(index == kCoinTypeTA) {
        name = @"coinTA";
    }

    else if(index == kCoinTypeNyan) {
        name = @"coinNyan2";
    }


    else if(index == kCoinTypeEmoji) {

        //if(kAppDelegate.inReview)
        if(YES)
            name = @"coinEmojiSafe1"; //safe
        else
            name = @"coinEmoji1"; //good
    }

    else if(index == kCoinTypeValentine) {
        name = @"coinZoella";
    }

    else if(index == kCoinTypePatrick) {
        name = @"coinPatrick1";
    }
    
    else if(index == kCoinTypeSoccer) {
        
        //default
        //name = @"coin3";
        name = @"coinSoccer1"; //soccer ball
        
    }
    
    else {
        //default
        Log(@"getCoinImageNameIndexRandom: default");
        name = @"coin3"; //coin2

    }


    assert(name);
    return name;

}

+(NSArray*)getSpikeArrayWithLevel:(int)level all:(BOOL)all;
{
    BOOL premium = [kAppDelegate isPremium];

    //force all in premium
    if(premium)
    {
        //all = YES;
        level = 20; //100
    }

    NSMutableArray *spikeArray = [@[] mutableCopy];

    [spikeArray addObject:@"spike"]; //regular
    [spikeArray addObject:@"spike"]; //regular

    if(level >= 2)
        [spikeArray addObject:@"spike5"]; //flat

    if(level >= 3)
    {
        [spikeArray addObject:@"spike4"]; //megaman
        [spikeArray addObject:@"spike10"]; //gradius
    }

    if(level >= 4)
        //[spikeArray addObject:@"spike6"]; //wanna
        [spikeArray addObject:@"spike7"]; //sword

    //if(level >= 5)
    //   [spikeArray addObject:@"spike11"]; //sonic

    if(level >= 5)
    {
        NSMutableArray * flappyArray = [@[
                                          @"spike9_2", //pipe red
                                          @"spike9_3", //pipe gray
                                          ] mutableCopy];;
        if(kAppDelegate.subLevel == 4 && !all)
        {
            //just gray and red
        }
        else
        {
            //green only premium
            if([kAppDelegate isPremium] || all)
            {
                //green only premium
                [flappyArray addObjectsFromArray:@[
                                                   @"spike9", //green
                                                   @"spike9",
                                                   ]];
            }
        }
        [spikeArray addObject:[flappyArray randomObject]]; //flappy
    }

    if(level >= 6)
        [spikeArray addObject:@"spike3"]; //blue-gray

    if(level >= 7)
        [spikeArray addObject:@"spike8"]; //beast

    //flappy
    if([kAppDelegate getSkin] == kCoinTypeFlap || all)
    {
        NSArray *flappyArray = nil;
        if(kAppDelegate.subLevel == 4 && !all)
        {
            //just gray and red
            flappyArray = @[
                            @"spike9_2",
                            @"spike9_3",
                            ];

        }
        else
        {
            flappyArray = @[
                            @"spike9",
                            @"spike9",
                            @"spike9_2",
                            @"spike9_3",
                            ];
        }

        [spikeArray addObject:[flappyArray randomObject]]; //flappy
        [spikeArray addObject:[flappyArray randomObject]]; //flappy
    }


	//by skin, add/remove
	int index = [kAppDelegate getSkin];

	if(index == kCoinTypeMario) {
		//mario
        [spikeArray addObject:@"spike9"]; //flappy
        [spikeArray addObject:@"spike9"]; //flappy
        [spikeArray addObject:@"spike9_2"]; //flappy
        [spikeArray addObject:@"spike9_3"]; //flappy
	}
	else if(index == kCoinTypeFlap) {
		//flappy
        [spikeArray addObject:@"spike9"]; //flappy
        [spikeArray addObject:@"spike9"]; //flappy
        [spikeArray addObject:@"spike9_2"]; //flappy
        [spikeArray addObject:@"spike9_3"]; //flappy
	}


	//cleanup

    if(kAppDelegate.inReview && !all)
    {
        //remove unsafe
        [spikeArray removeObject:@"spike4"]; //megaman
        [spikeArray removeObject:@"spike8"]; //beast
        [spikeArray removeObject:@"spike9"]; //flappy
        [spikeArray removeObject:@"spike9_2"]; //flappy
        [spikeArray removeObject:@"spike9_3"]; //flappy
    }

    if(kAppDelegate.isPremium && !all)
    {
        //only vip
        [spikeArray removeObject:@"spike9"]; //flappy
        [spikeArray removeObject:@"spike9_2"]; //flappy
        [spikeArray removeObject:@"spike9_3"]; //flappy
        [spikeArray removeObject:@"spike7"]; //sword
    }


    //force
    if([kHelpers isDebug]) {
//        [spikeArray removeAllObjects];
//        [spikeArray addObject:@"spike10"]; //gradius
    }

    return spikeArray;
}

+(NSArray*)getFireballArrayWithLevel:(int)inLevel all:(BOOL)all
{
    NSString *name = nil;
    BOOL premium = [kAppDelegate isPremium];

    //force all in premium
    if(premium)
    {
        //all = YES;
        inLevel = 20; //100
    }

    name = @"fireball3"; //default, zelda

    NSMutableArray *array = [NSMutableArray array];

    for(int level=1; level<=inLevel; level++) {

        int i = 1;
        if(level >= i) {
            [array addObject:@"fireball3"]; //zelda red
        }

        i++; //2
        if(level >= i)
        {
            [array addObject:@"fireball4"]; //zelda blue
        }
        if(level >= i)
        {
            [array addObject:@"fireball10"]; //bat
        }


        i++; //3
        if(level >= i)
        {
            [array addObject:@"fireball5"]; //canon
        }
        if(level >= i)
        {
            [array addObject:@"fireball8"]; //zelda ball
        }

        i++; //4
        if((premium && !kAppDelegate.inReview) || all)
        {
            if(level >= i)
            {
                [array addObject:@"fireball18"]; //turtle green
            }
        }
        if(level >= i)
        {
            [array addObject:@"fireball11"]; //bat red

            if(!kAppDelegate.inReview || all)
                [array addObject:@"fireball23"]; //barrel
        }

        i++; //5
        if(level >= i)
        {
            [array addObject:@"fireball12"]; //boulder

            if(!kAppDelegate.inReview || all)
                [array addObject:@"fireball24"]; //cactus

        }
        if(level >= i)
        {
            [array addObject:@"fireball9"]; //megaman2 black spike

            [array addObject:@"fireball22"]; //illuminati
        }

        i++; //6
        if(level >= i)
        {
            [array addObject:@"fireball16"]; //invader 1
            [array addObject:@"fireball21"]; //invader 3
        }
        //if(premium && !kAppDelegate.inReview)
        {
            if(level >= i)
            {
                [array addObject:@"fireball20"]; //turtle red
            }
        }

        /*i++; //?
         if(level >= i)
         {
         [array addObject:@"fireball13"]; //fireball14 //ninja
         }*/

        i++; //7
        if(premium || all)
        {
            i++;
            if(level >= i)
            {
                [array addObject:@"fireball19"]; //spikes metal white

            }
        }
        if(level >= i)
        {
            [array addObject:@"fireball17"]; //invader 2
        }


        i++; //8
        if(level >= i && (premium || all))
        {
            [array addObject:@"fireball6"]; //spin wrench
        }
        if(level >= i)
        {
            [array addObject:@"fireball7"]; //asteroid

        }

        i++; //9
        if(level >= i)
        {
            [array addObject:@"fireball15"]; //saw blade

        }

        //last, only if premium and not review?
        i++; //10
        if((premium && !kAppDelegate.inReview) || all)
        {
            if(level >= i)
            {
                [array addObject:@"fireball1"]; //mario
            }
        }

        //by skin, add/remove
        int index = [kAppDelegate getSkin];

        if(index == kCoinTypePew) {
            //pew more barrels
//            [array addObject:@"fireball23"]; //barrel
//            [array addObject:@"fireball23"]; //barrel
//            [array addObject:@"fireball23"]; //barrel
//            [array addObject:@"fireball23"]; //barrel
        }
		else if(index == kCoinTypeMario) {
            //mario more turtles, barrels
           [array addObject:@"fireball18"]; //turtle green
           [array addObject:@"fireball18"]; //turtle green
		   [array addObject:@"fireball20"]; //turtle red
		   [array addObject:@"fireball20"]; //turtle red
		   [array addObject:@"fireball23"]; //barrel
		   [array addObject:@"fireball23"]; //barrel
		   [array addObject:@"fireball5"]; //canon
           [array addObject:@"fireball5"]; //canon
		   [array addObject:@"fireball6"]; //spin wrench
           [array addObject:@"fireball24"]; //cactus

		   //[array addObject:@"fireball19"]; //spikes metal white

        }
		else if(index == kCoinTypeZelda) {
            //zelda, more

            [array addObject:@"fireball10"]; //bat
            [array addObject:@"fireball10"]; //bat
			[array addObject:@"fireball11"]; //bat red
			[array addObject:@"fireball11"]; //bat red
            [array addObject:@"fireball8"]; //zelda ball
            [array addObject:@"fireball8"]; //zelda ball
            [array addObject:@"fireball3"]; //zelda red
            [array addObject:@"fireball3"]; //zelda red
            [array addObject:@"fireball4"]; //zelda blue
            [array addObject:@"fireball4"]; //zelda blue
        }
    }

	//cleanup in review?
    if((!kAppDelegate.isPremium || kAppDelegate.inReview) && !all)
    {
        [array removeObject:@"fireball1"]; //mario
		[array removeObject:@"fireball18"]; //turtle green
        [array removeObject:@"fireball19"]; //spikes metal white
        [array removeObject:@"fireball6"]; //spin wrench
        [array removeObject:@"fireball24"]; //cactus
    }

    //force
    if([kHelpers isDebug]) {
        //        [array removeAllObjects];

//        [array addObject:@"fireball24"]; //cactus
//        [array addObject:@"fireball24"]; //cactus
//        [array addObject:@"fireball24"]; //cactus
//        [array addObject:@"fireball24"]; //cactus
//        [array addObject:@"fireball24"]; //cactus
//        [array addObject:@"fireball24"]; //cactus
//        [array addObject:@"fireball24"]; //cactus
    }

    return array;
}

+(NSString*)getFireballName {

    NSArray *array = [self getFireballArrayWithLevel:kAppDelegate.level all:NO];
    NSString *name = [array randomObject];

    return name;
}

+(NSString*)getBlockImageNameIndex:(int)index {

    NSString *name = nil;


    if(index == kCoinTypeDefault) {
        name = @"block5Frame1";
    }

    else if(index == kCoinTypeFlat) {
        name = @"block6Frame1";
    }
    else if(index == kCoinTypeMega) {
        name = @"block7Frame1";
    }

    else if(index == kCoinTypeMine) {
        name = @"block8Frame1";
    }

    else if(index == kCoinTypeMetal) {
        name = @"block22Frame1";
    }

    else if(index == kCoinTypeYoshi) {
        name = @"block9Frame1";
    }

    else if(index == kCoinTypeSonic) {
        name = @"block10Frame1";
    }
    else if(index == kCoinTypePew) {
        name = @"block11Frame1";
    }
    else if(index == kCoinTypeZelda) {
        name = @"block13Frame1";
    }

    else if(index == kCoinTypeBitcoin) {
        name = @"block14Frame1";
    }
    else if(index == kCoinTypeMac) {
        name = @"block15Frame1";
    }
    else if(index == kCoinTypeFlap) {
        name = @"block12Frame1";
    }
    else if(index == kCoinTypeMario) {
        name = @"block4Frame1"; //mario brick
        //name = @"block23Frame1"; //question
    }
    else if(index == kCoinTypeMario2) {

        if(kAppDelegate.inReview)
            name = @"block23Black2Frame1"; //darker
        else
            name = @"block23BlackFrame1";

    }

    else if(index == kCoinTypeComingSoon) {
        name = @"block24Frame1";
    }

    else if(index == kCoinTypeGameboy) {
        name = @"block16Frame1";
    }
    else if(index == kCoinTypeBrain) {
        name = @"blockNegaFrame1";
    }
    else if(index == kCoinTypeZoella) {
        name = @"block17Frame1";
    }

    else if(index == kCoinTypeMontreal) {
        name = @"block18Frame1";
    }
    else if(index == kCoinTypeTA) {
        name = @"block19Frame1";
    }

    else if(index == kCoinTypeNyan) {
        name = @"block20Frame1";
    }
    else if(index == kCoinTypeValentine) {
        name = @"blockValentineFrame1";
    }
    else if(index == kCoinTypePatrick) {
        name = @"blockPatrickFrame1";
    }
    else if(index == kCoinTypeSoccer) {
        name = @"blockSoccerFrame1";
    }

    else if(index == kCoinTypeEmoji) {
        if(kAppDelegate.inReview)
        {
            //apple approved
            name = @"block21Frame1_2";
        }
        else
        {
            //original emoji apple
            //name = @"block21Frame1";
            //samsung
            name = @"block21Frame1_3";
        }
    }


    else {
        //default
        Log(@"getBLockImageNameIndex: default");
        name = @"block5Frame1";

    }

    return name;
}

+(NSString*)getBlockImageName {

    NSString *name = nil;

    name = [CBSkinManager getBlockImageNameIndex:(int)[kAppDelegate getSkin]];
    assert(name);
    return name;
}

+(UIImage*)getTutoArrowImage {
    int index = (int)[kAppDelegate getSkin];
    return [self getTutoArrowImage:index];
}

+(NSString*)getTutoArrowImageName {

    NSString *name = nil;

    //if(kAppDelegate.inReview)
    if(NO)
    {
        //apple approved
        //name = @"tuto_arrow2";
        name = @"tuto_arrow";

    }
    else
    {
        //good
        name = @"tuto_arrow";
    }

    return name;
}

+(UIImage*)getTutoArrowImage:(int)index {

    UIImage *image = nil;
    NSString *name = [self getTutoArrowImageName];

    //disable, force

    image = [UIImage imageNamed:name];
    return image;

}


+(UIImage*)getBlockImage
{
    UIImage *image = nil;

    image = [UIImage imageNamed:[CBSkinManager getBlockImageName]];
    //assert(image);
    return image;
}



+(int)getBlockType:(int)index
{
    int type  = 0;


    if(index == kCoinTypeNone) {
        type = kCoinTypeCommon;
    }
    else if(index == kCoinTypeDefault) {
        type = kCoinTypeCommon;
    }
        else if(index == kCoinTypeFlat) {
        type = kCoinTypeUncommon;
    }
    else if(index == kCoinTypeMega) {
        type = kCoinTypeUncommon;
    }
    else if(index == kCoinTypeMine) {
        type = kCoinTypeUncommon;
    }
    else if(index == kCoinTypeMetal) {
        type = kCoinTypeUncommon;
    }
    else if(index == kCoinTypeBitcoin) {
        type = kCoinTypeUncommon;
    }
    else if(index == kCoinTypeZelda) {
        type = kCoinTypeUncommon;
    }
    else if(index == kCoinTypeFlap) {
        type = kCoinTypeRare;
    }
    else if(index == kCoinTypeYoshi) {
        type = kCoinTypeRare;
    }
    else if(index == kCoinTypeSonic) {
        type = kCoinTypeRare;
    }
    else if(index == kCoinTypeEmoji) {
        type = kCoinTypeRare;
    }
    else if(index == kCoinTypeValentine) {
        type = kCoinTypeRare;
    }
    else if(index == kCoinTypePatrick) {
        type = kCoinTypeRare;
    }
    else if(index == kCoinTypeSoccer) {
        type = kCoinTypeRare;
    }
    else if(index == kCoinTypePew) {
        type = kCoinTypeEpic;
    }
    else if(index == kCoinTypeMario) {
        type = kCoinTypeEpic;
    }
    else if(index == kCoinTypeMario2) {
        type = kCoinTypeEpic;
    }

    else if(index == kCoinTypeComingSoon) {
        type = kCoinTypeCommon;
    }

    else if(index == kCoinTypeGameboy) {
        type = kCoinTypeRare;
    }

    else if(index == kCoinTypeTA) {
        type = kCoinTypeRare;
    }

    else if(index == kCoinTypeBrain) {
        type = kCoinTypeEpic;
    }
    else
    {
        if([kHelpers isDebug])
            assert(0);
    }

    return type;
}


+(NSString*)getBlockTypeName:(int)index
{
    NSString *name = nil;

    int type = [self getBlockType:index];

    if(type == kCoinTypeCommon) {
        name = @"Common";
    }
    else if(type == kCoinTypeUncommon) {
        name = @"Uncommon";
    }
    else if(type == kCoinTypeRare) {
        name = @"Rare";
    }
    else if(type == kCoinTypeEpic) {
        name = @"Epic";
    }
    else if(type == kCoinTypeLegendary) {
        name = @"Legendary";
    }
    else
    {
        if([kHelpers isDebug])
            assert(0);
    }

    return name;
}

+(UIColor*)getBlockTypeColor:(int)index
{
    UIColor *color =[UIColor whiteColor];

    int type = [self getBlockType:index];

    /*
     Poor	157	157	157	0.62	0.62	0.62	#9d9d9d	Gray
     Common	255	255	255	1.00	1.00	1.00	#ffffff	White
     Uncommon	30	255	0	0.12	1.00	0.00	#1eff00	Green
     Rare	0	112	221	0.00	0.44	0.87	#0070dd	Blue
     Epic	163	53	238	0.64	0.21	0.93	#a335ee	Purple
     Legendary	255	128	0	1.00	0.50	0.00	#ff8000	Orange
     Artifact	230	204	128	0.90	0.80	0.50	#e6cc80	Light Gold
     Heirloom	0	204	255	0.00	0.8	1.0	#00ccff	Blizzard Blue
     WoW Token	0	204	255	0.00	0.8	1.0	#00ccff	Blizzard Blue
     */


    if(type == kCoinTypeCommon) {
        color = [UIColor colorWithHex:0xeeeeee]; //white
    }

    else if(type == kCoinTypeUncommon) {
        color = [UIColor colorWithHex:0x1eff00]; //green
    }

    else if(type == kCoinTypeRare) {
        color = [UIColor colorWithHex:0x188dff]; //blue
    }

    else if(type == kCoinTypeEpic) {
        color = [UIColor colorWithHex:0xb241ff];  //purple
    }
    else if(type == kCoinTypeLegendary) {
        color = [UIColor colorWithHex:0xff8000]; //orange
    }

    return color;
}

//unlock level
+(int)getBlockUnlockLevel:(int)index
{
    int level = 1;
    //int mult = 1;

    level = index;

    return level;
}

+(NSString *)getSkinBackground {
    return [self getSkinBackgroundIndex:(int)[kAppDelegate getSkin]];
}

+(NSString *)getSkinBackground:(BOOL)random {
    return [self getSkinBackgroundIndex:(int)[kAppDelegate getSkin] random:random];
}

+(NSString *)getSkinBackgroundIndex:(int)index {
   return [self getSkinBackgroundIndex:index random:NO];
}

+(NSString *)getSkinBackgroundIndex:(int)index random:(BOOL)random {

    NSString *bgName = nil;

    if(index == kCoinTypeDefault) {
        //bgName = nil;
        /*if(kAppDelegate.numEndings > 0)
            bgName = @"background_glitch";
        else*/
            bgName = @"background1";
    }
    else if(index == kCoinTypeFlat) {
        bgName = @"background_ket";
    }
    else if(index == kCoinTypeMega) {
        bgName = @"background31";
    }
    else if(index == kCoinTypeMine) {
        bgName = @"background_minecraft";
    }
    else if(index == kCoinTypeMetal) {
        bgName = @"background_metal";
    }
    else if(index == kCoinTypeYoshi) {
        bgName = @"background_yoshi";
    }
    else if(index == kCoinTypeSonic) {
        bgName = @"background_sonic";
    }

    else if(index == kCoinTypePew) {
        bgName = @"background_pew";
    }

    else if(index == kCoinTypeZelda) {
        bgName = @"background2";
    }

    else if(index == kCoinTypeBitcoin) {
        if(random && kAppDelegate.level >= 5)
        {
            //random, amiga
            bgName = [@[
                        @"background_bitcoin",
                        @"background_bitcoin",
                        @"background_bitcoin",

                        //@"background_amiga",

                    ] randomObject];
        }
        else
            bgName = @"background_bitcoin";
    }

    else if(index == kCoinTypeMac) {
        bgName = nil;
    }

    else if(index == kCoinTypeFlap) {

        if(![kHelpers isNight])
            bgName = @"background_flap";
        else
            bgName = @"background_flap2"; //night
    }

    else if(index == kCoinTypeMario) {
        bgName = @"background_mario";
    }
    else if(index == kCoinTypeGameboy) {
        bgName = @"background_gameboy";
    }

    else if(index == kCoinTypeZoella) {
        bgName = @"background_zoella";
    }

    else if(index == kCoinTypeMontreal) {
        bgName = @"background_mtl";
    }

    else if(index == kCoinTypeTA) {
        bgName = @"background_ta";
    }
    else if(index == kCoinTypeBrain) {
        bgName = @"background_levelup"; //@"background_brain";
    }
    else if(index == kCoinTypeNyan) {
        bgName = @"background_nyan";
    }
    else if(index == kCoinTypeEmoji) {
        bgName = @"background_emoji";
    }
    else if(index == kCoinTypeValentine) {
        bgName = @"background_valentine";
    }
    else if(index == kCoinTypePatrick) {
        bgName = @"background_patrick";
    }
    else if(index == kCoinTypeSoccer) {
        bgName = @"background_soccer";
    }
    else if(index == kCoinTypeMario2) {
        bgName = @"background_levelup";
    }
    else if(index == kCoinTypeComingSoon) {
        bgName = @"background_levelup";
    }

    return bgName;
}

+(SKTexture*)getPowerupSquareImageTexture:(PowerupType) type
{
	return [CBSkinManager getPowerupSquareImageTexture:type blur:NO];

}
+(SKTexture*)getPowerupSquareImageTexture:(PowerupType)type blur:(BOOL)blur
{
    SKTexture *texture = [SKTexture textureWithImage:[CBSkinManager getPowerupSquareImage:type blur:blur]];
    assert(texture);
    return texture;
}

+(UIImage*)getPowerupSquareImage:(PowerupType)type;
{
	return [CBSkinManager getPowerupSquareImage:type blur:NO];
}

+(NSString*)getPowerupSquareImageName:(PowerupType)type;{
    NSString *name = nil;


    if(type == kPowerUpTypeStar) {
        //if(blur)
        name = @"power_up_star";
    }
    else if(type == kPowerUpTypeHeart) {
        name = @"power_up_heart";
    }
    else if(type == kPowerUpTypePotion) {
        name = @"power_up_potion";
    }
    else if(type == kPowerUpTypeDoubler) {
        name = @"power_up_doubler";
    }
    else if(type == kPowerUpTypeAuto) {
        name = @"power_up_auto";
    }
    else if(type == kPowerUpTypeWeak) {
        name = @"power_up_weak";
    }
    else if(type == kPowerUpTypeShield) {
        name = @"power_up_shield";
    }
    else if(type == kPowerUpTypeGrow) {
        name = @"power_up_grow";
    }
    else if(type == kPowerUpTypeShrink) {
        name = @"power_up_shrink";
    }
    else if(type == kPowerUpTypeInk) {
        name = @"power_up_ink";
    }
    else if(type == kPowerUpTypeBomb) {
        name = @"power_up_bomb";
    }

    else if(type == kPowerUpTypeCoins) {
        name = @"power_up_coin";
    }
    else if(type == kPowerUpTypeFeather) {
        name = @"power_up_feather";
    }
    else if(type == kPowerUpTypeClock) {
        name = @"power_up_clock";
    }
    else if(type == kPowerUpTypeRedCoin) {
        name = @"coinRed2Frame1";
    }
    else if(type == kPowerUpTypePow) {
        name = @"power_up_pow";
    }
    else if(type == kPowerUpTypeNut) {
        name = @"power_up_nut";
    }
    else if(type == kPowerUpTypeBanana) {
        name = @"power_up_banana";
    }

    return name;
}

+(UIImage*)getPowerupSquareImage:(PowerupType)type blur:(BOOL)blur;
{
    UIImage *image = nil;

    image = [UIImage imageNamed:[CBSkinManager getPowerupSquareImageName:type]];
    assert(image);

	if(blur)
	{
		image = [kHelpers getBlurredImage:image];
	}

    assert(image);

    return image;
}

+(NSArray*)getAvailablePowerups
{
  return [self getAvailablePowerupsWithLevel:kAppDelegate.level];
}

+(NSArray*)getAvailablePowerupsWithLevel:(int)level
{
    BOOL premium = [kAppDelegate isPremium];

    NSMutableArray *array = [NSMutableArray array];

    for(int i=0;i<kPowerUpTypeCount;i++)
    {
        //buff by level
        if(level < 2 && !premium)
        {
            if(i == kPowerUpTypeDoubler)
                continue; //skip
        }

        if(level < 2 && !premium)
        {
            if(i == kPowerUpTypeDoubler)
                continue; //skip
        }

        if(level < 3 && !premium)
        {
            if(i == kPowerUpTypeWeak)
                continue; //skip
        }

        if(level < 3 && !premium)
        {
            if(i == kPowerUpTypeAuto)
                continue; //skip
        }

        if(level < 1 && !premium)
        {
            if(i == kPowerUpTypeShield)
                continue; //skip
        }

        if(level < 2 && !premium)
        {
            if(i == kPowerUpTypeGrow)
                continue; //skip
        }

        if(level < 4 && !premium)
        {
            if(i == kPowerUpTypeShrink)
                continue; //skip
        }

        if(level < 3 && !premium)
        {
            if(i == kPowerUpTypeInk)
                continue; //skip
        }


        //by story level
        if(level < kStoryLevel1  && !premium)
        {
            //???
        }

        if(level < kStoryLevel2  && !premium)
        {
            //???
        }


        if((kAppDelegate.currentBuff != kBuffTypeNone ) && (i == kAppDelegate.currentBuff))
        {
            //skip if this buff if already active
            continue;
        }


        //add it, if not skipped
        [array addObject:@(i)];
    }

    return array;
}

@end
