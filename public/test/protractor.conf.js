exports.config = {
  specs: [
    './e2e/compiled/**/*.spec.js'
  ],
  baseUrl: 'http://localhost:8080',
  chromeOnly: true,
  chromeDriver: '../node_modules/protractor/selenium/chromedriver',
  seleniumServerJar: '../node_modules/protractor/selenium/selenium-server-standalone-2.42.2.jar'
}
