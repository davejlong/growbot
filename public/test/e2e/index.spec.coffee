chai = require 'chai'
chaiAsPromised = require 'chai-as-promised'

chai.use chaiAsPromised
expect = chai.expect

###
describe 'hello-protractor', ->
  describe 'index', ->
    it 'should display the correct title', ->
      browser.get '/'
      title = element By.binding 'title'
      expect(title.getText()).to.eventually.equal 'Growbot'
    it 'should show a barchart with 4 bars', ->
      browser.get '/'
      expect(element.all(By.tagName('rect')).count()).to.eventually.equal 4
###
