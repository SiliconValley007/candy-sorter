/// we define these strings here, so that if we need to change anything, we can change it in one place and it will be reflected throughout our app, instead of us having to find each occurrence of the string and replacing it. 

// constant strings for all the assets we need
const String bowlSvg = 'assets/bowl.svg';
const String candySvg = 'assets/candy.svg';
const String gameOverAnimation = 'assets/game-over.json';
const String gamePausedAnimation = 'assets/game-paused.json';
const String gameWonAnimation = 'assets/game-won.json';
const String loadingAnimation = 'assets/loading-among-us.json';

// constant strings for the route names
const String home = '/';
const String startGame = '/start-game';
const String gameScreen = '/game-screen';
const String settingsScreen = '/settings-screen';

// constant strings for the keys we use while storing the user preferences in shared preferences
const String noOfCandyKey = 'no-of-candy-key';
const String gameColorsKey = 'game-colors-key';
