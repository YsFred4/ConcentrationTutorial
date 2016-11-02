using System;
using System.Collections.Generic;
using System.Diagnostics;
using System.Linq;
using System.Reflection.Emit;
using System.Text;

using Xamarin.Forms;

namespace ConcentrationTutorial
{
    /*
    BOOL ipad;
    id deviceType;
    NSString* fontstring;
    NSString* appTitle;
    NSString* alertTitle;
    NSString* alertMessage;
    id fontcolor;
    UIView* topMenuView;
    UILabel* topTitle;
    NSInteger baselevel, level, maxlevel, screenwidth, screenheight, maxcolumn, maxrow, barheight, fontsize, buttonsize, picWidth, picHeight, lastChoice, numMoves, gridsize;

    NSMutableArray* imageArray;
    NSMutableArray* gridArray;
    NSMutableArray* revealedArray;

    UIButton* settingsButton;
    UIButton* helpButton;
    UIView* gridView;
    UIAlertView* alert;
    */

    public class GamePage : ContentPage
    {
        bool ipad;
        TargetIdiom deviceType;
        string fontstring;
        string appTitle;
        string alertTitle;
        string alertMessage;
        Color fontcolor;
        Grid topMenuView;
        Label topTitle;
        int baselevel, level, maxlevel, screenwidth, screenheight, maxcolumn, maxrow, barheight, fontsize, buttonsize, picWidth, picHeight, lastChoice, numMoves, gridsize;

        List<string> imageArray;
        List<string> gridArray;
        List<bool> revealedArray;

        Button settingsButton;
        Button helpButton;
        Grid gridView;
        //UIAlertView* alert;

        public GamePage()
        {
            Content = new Grid
            {
                RowDefinitions = new RowDefinitionCollection
                {
                    new RowDefinition() { Height=new GridLength(1,GridUnitType.Auto) },
                    new RowDefinition() { Height=new GridLength(1,GridUnitType.Star) }
                }
            };
        }

        protected override void OnAppearing()
        {
            initializeVariables();
            resetGrid();
            showMenus();
            showGrid();

            base.OnAppearing();
        }

        void initializeVariables()
        {
            level = 1;
            baselevel = 1;
            maxlevel = 10;

            deviceType = Device.Idiom;
            if (deviceType == TargetIdiom.Tablet)
                ipad = true;
            else
                ipad = false;

            fontstring = "";
            fontcolor = Color.Black;
            fontsize = 24;
            barheight = 60;
            buttonsize = 60;
            picWidth = 60;
            picHeight = 100;

            if (ipad == true)
            {
                picWidth = 2 * picWidth;
                picHeight = 2 * picHeight;
            }

            appTitle = @"Match the Pictures";
            imageArray = new List<string>()
            { "one", "two", "three", "four", "five", "six" };
        }

        void resetGrid()
        {
            try
            {
                lastChoice = -1;
                numMoves = 0;

                switch (level)
                {
                    case 1: gridsize = 4; maxcolumn = 2; break;
                    case 2: gridsize = 6; maxcolumn = 3; break;
                    case 3: gridsize = 8; maxcolumn = 4; break;
                    case 4: gridsize = 12; maxcolumn = 4; break;
                    case 5: gridsize = 16; maxcolumn = 4; break;
                    case 6: gridsize = 20; maxcolumn = 5; break;
                    case 7: gridsize = 24; maxcolumn = 6; break;
                    case 8: gridsize = 30; maxcolumn = 6; break;
                    case 9: gridsize = 36; maxcolumn = 6; break;
                    case 10: gridsize = 42; maxcolumn = 7; break;
                    case 11: gridsize = 48; maxcolumn = 8; break;
                }

                revealedArray = new List<bool>();
                gridArray = new List<string>();

                var arc4random = new Random();

                int ctroffset = (arc4random.Next() % imageArray.Count);

                for (int ctr = 0; ctr < gridsize; ctr++)
                {
                    revealedArray.Add(false);
                    gridArray.Add("");
                }

                for (int ctr = 0; ctr < gridsize / 2; ctr++)
                {
                    int fixedctr = ctr + ctroffset;
                    fixedctr %= imageArray.Count;

                    string newobject = imageArray[fixedctr];

                    int pos1 = (arc4random.Next() % gridsize);
                    bool notFree = true;
                    while (notFree)
                    {
                        if (gridArray[pos1] == "")
                        {
                            notFree = false;
                            gridArray[pos1] = newobject;
                        }
                        else
                        {
                            pos1++;
                            if (pos1 >= gridsize)
                            {
                                pos1 = 0;
                            }
                        }
                    }

                    int pos2 = (arc4random.Next() % gridsize);
                    notFree = true;
                    while (notFree)
                    {
                        if (gridArray[pos2] == "")
                        {
                            notFree = false;
                            gridArray[pos2] = newobject;
                        }
                        else
                        {
                            pos2++;
                            if (pos2 >= gridsize)
                            { pos2 = 0; }
                        }
                    }
                }
            }
            catch(Exception ex)
            {

            }
        }

        void showMenus()
        {
            if (topMenuView != null)
                ((Grid)this.Content).Children.Remove(topMenuView);

            topMenuView = new Grid()
            {
                HeightRequest = barheight,
                WidthRequest = screenwidth,
                BackgroundColor = Color.Black,
                VerticalOptions = LayoutOptions.Start,
                ColumnDefinitions = new ColumnDefinitionCollection
                {
                    new ColumnDefinition { Width=new GridLength(1,GridUnitType.Star) },
                    new ColumnDefinition { Width=new GridLength(1,GridUnitType.Auto) },
                }

            };


            topTitle = new Label()
            {
                WidthRequest = screenwidth - 2 * barheight,
                HeightRequest = barheight,
                HorizontalTextAlignment = TextAlignment.Center,
                TextColor = Color.White,
                Text = appTitle,
                FontSize = fontsize
            };
            topMenuView.Children.Add(topTitle,0,0);
            helpButton = new Button()
            {
                WidthRequest = buttonsize,
                HeightRequest = buttonsize,
                Image = (FileImageSource)FileImageSource.FromFile("Help.png")
            };
            helpButton.Clicked += (s, e) =>
            {
                alertTitle = string.Format(@"Welcome to {0}!", appTitle);
                alertMessage = @"You can't pick a level yet";
                // show help
                DisplayAlert(alertTitle, alertMessage, "Close");
            };
            topMenuView.Children.Add(helpButton,1,0);
            ((Grid)this.Content).Children.Add(topMenuView,0,0);
        }

        void showGrid()
        {
            if (gridView != null)
                ((Grid)this.Content).Children.Remove(gridView);

            gridView = new Grid()
            {
                //VerticalOptions = LayoutOptions.End,
                WidthRequest = screenwidth,
                HeightRequest = screenheight - barheight,
                IsClippedToBounds = true,
                BackgroundColor = Color.Green,
                
            };
            gridView.ColumnDefinitions = new ColumnDefinitionCollection();
            gridView.RowDefinitions = new RowDefinitionCollection();
            for (int MyCount = 0; MyCount < maxcolumn; MyCount++)
            {
                gridView.ColumnDefinitions.Add(new ColumnDefinition { Width = new GridLength(1, GridUnitType.Star) });
            }

            maxrow = gridsize / maxcolumn;

            for (int MyCount = 0; MyCount < maxrow; MyCount++)
            {
                gridView.RowDefinitions.Add(new RowDefinition { Height = new GridLength(1, GridUnitType.Star) });
            }
            //        gridView.backgroundColor =  [UIColor colorWithPatternImage:[UIImage imageNamed:@"greenfeltsmall.jpg"]];


            picWidth = screenwidth / (maxcolumn + 1);
            picHeight = picWidth * 4 / 3;

            float xspacing = (screenwidth - maxcolumn * picWidth) / maxcolumn;
            float ymargin = xspacing;

            int column, row, i, offset;

            column = 0;
            row = 0;
            i = 0;
            string item;

            offset = (screenwidth - (maxcolumn * buttonsize)) / (1 + maxcolumn);
            ImageSource bgImage = ImageSource.FromFile(@"PlayingCardBack.png");

            while (i < gridArray.Count)
            {
                item = gridArray[i];
                Button button = new Button()
                {
                    BackgroundColor = Color.Transparent,
                    HeightRequest = picHeight,
                    WidthRequest = picWidth,
                    CommandParameter = i
                };
                ImageSource thisImage = ImageSource.FromFile(item + ".png");

                var buttonImage = new Image
                {
                    Aspect = Aspect.AspectFit,
                    VerticalOptions = LayoutOptions.Center,
                    HorizontalOptions = LayoutOptions.Center,
                };

                if (revealedArray[i] == true)
                {
                    buttonImage.Source = thisImage;                }
                else
                {
                    buttonImage.Source = bgImage;
                }
                buttonImage.InputTransparent = true;
                button.Clicked += (s, e) =>
                {
                    Button thisbutton = (Button)s;
                    int choice = (int)thisbutton.CommandParameter;
                    string chosenImage = string.Format(@"{0}.png", gridArray[choice]);

                    topTitle.Text = string.Format(@"{0}: {1}", appTitle, gridArray[choice].ToUpper());

                    if (!revealedArray[choice] == true)
                    {
                        numMoves++;
                        revealedArray[choice] = true;
                        showGrid();
                        if (lastChoice == -1)
                        {
                            lastChoice = choice;
                        }
                        else
                        {
                            if (!(lastChoice == choice) && (gridArray[lastChoice] == gridArray[choice]))
                            {
                                lastChoice = -1;
                                bool done = true;
                                for (int tmpctr = 0; tmpctr < revealedArray.Count; tmpctr++)
                                {
                                    if (revealedArray[tmpctr] == false)
                                    {
                                        done = false;
                                    }
                                }
                                if (done)
                                {
                                    if (level < maxlevel)
                                    {
                                        level++;
                                    }
                                    showDone();
                                }
                                topTitle.Text = appTitle;
                            }
                            else
                            { // reset revealed
                                showGrid();
                                revealedArray[choice] = false;
                                revealedArray[lastChoice] = false;
                            }
                            lastChoice = -1;
                        }
                    }
                };
                gridView.Children.Add(button, column, row);
                gridView.Children.Add(buttonImage, column, row);
                column++;
                if (column >= maxcolumn) { column = 0; row++; }
                i++;
            }
            ((Grid)this.Content).Children.Add(gridView, 0, 1);
        }

        void showDone()
        {
            topTitle.Text = string.Format("{0}: {1} Moves", appTitle, numMoves);
            alertTitle = string.Format("SOLVED in {0} MOVES!", numMoves);
            if (level == maxlevel) { alertMessage = @"Well done! Try again!"; }
            else { alertMessage = string.Format(@"Well done! Now try again, at level {0}", (long)level); }
            showAlert();
            resetGrid();
            showGrid();
        }

        void showAlert()
        {
            DisplayAlert(alertTitle, alertMessage, "Continue");
        }

        void showAll()
        {

            float duration = imageArray.Count / 5;

            //View animatedOverlay =

            List<ImageSource> imgArray = new List<ImageSource>();

            for (int ctr = 0; ctr < imageArray.Count; ctr++)
            {
                string chosenImage = string.Format(@"{0}.png",imageArray[ctr]);
                ImageSource tempImg = ImageSource.FromFile(chosenImage);
                imgArray.Add(tempImg);
            }

    //animatedOverlay.animationImages = imgArray;
    //animatedOverlay.animationDuration = duration; // seconds
    //animatedOverlay.animationRepeatCount = 1; // 0 = loops forever
    //[[self view] addSubview:animatedOverlay];
    //[animatedOverlay startAnimating];
        }

    }
}
