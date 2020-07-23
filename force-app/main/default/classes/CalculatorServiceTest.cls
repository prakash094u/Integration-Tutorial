@isTest
public with sharing class CalculatorServiceTest {
    static Integer x = 6;
    static Integer y = 3;

    // Test method to test the Addition
    @isTest static void testAddCallout() {
        Test.setMock(WebServiceMock.class, new CalculatorServiceMock(CalculatorServiceMock.ADD_MODE));
        CalculatorService.CalculatorSoap calculator = new CalculatorService.CalculatorSoap();
        Integer result = calculator.Add(x, y);
        Integer expectedResult = x + y;

        System.assertEquals(expectedResult, result, 'Addition result should be : '+expectedResult);
    }

    // Test method to test the subtraction
    @isTest static void testSubCallout() {
        Test.setMock(WebServiceMock.class, new CalculatorServiceMock(CalculatorServiceMock.SUB_MODE));
        CalculatorService.CalculatorSoap calculator = new CalculatorService.CalculatorSoap();
        Integer result = calculator.subtract(x, y);
        Integer expectedResult = x - y;

        System.assertEquals(expectedResult, result, 'Subtraction result should be : '+expectedResult);
    }

    // Test method to test the Multiplication
    @isTest static void testMulResult() {
        Test.setMock(WebServiceMock.class, new CalculatorServiceMock(CalculatorServiceMock.MUL_MODE));
        CalculatorService.CalculatorSoap calculator = new CalculatorService.CalculatorSoap();
        Integer result = calculator.Multiply(x, y);
        Integer expectedResult = x * y;

        System.assertEquals(expectedResult, result, 'Multiplication Result should be : ' + expectedResult);
    }

    // Test method to test the division callout
    @isTest static void testDivResult() {
        Test.setMock(WebServiceMock.class, new CalculatorServiceMock(CalculatorServiceMock.DIV_MODE));
        CalculatorService.CalculatorSoap calculator = new CalculatorService.CalculatorSoap();
        Integer result = calculator.Divide(x, y);
        Integer expectedResult = x / y;

        System.assertEquals(expectedResult, result, 'Division result should be : '+ expectedResult);
    }
}
