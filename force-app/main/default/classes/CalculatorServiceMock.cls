@isTest
public with sharing class CalculatorServiceMock implements WebServiceMock {
    public String mode;
    public static String ADD_MODE = 'ADD_MODE';
    public static String SUB_MODE = 'SUB_MODE';
    public static String MUL_MODE = 'MUL_MODE';
    public static String DIV_MODE = 'DIV_MODE';

    public CalculatorServiceMock(string mockMode) {
        this.mode = mockMode;
    }

    public void doInvoke(
        Object stub,
        Object request,
        Map<String, Object> response,
        String endpoint,
        String soapAction,
        String requestName,
        String responseNS,
        String responseName,
        String responseType
    ) {
        switch on mode  {
            when 'ADD_MODE' {
                CalculatorService.AddResponse_element addResponse = new CalculatorService.AddResponse_element();
                addResponse.AddResult = 9;
                response.put('response_x', addResponse);
                
            }
            when 'SUB_MODE' {
                CalculatorService.SubtractResponse_element subResponse = new CalculatorService.SubtractResponse_element();
                subResponse.SubtractResult = 3;
                response.put('response_x', subResponse);
            }
            when 'MUL_MODE' {
                CalculatorService.MultiplyResponse_element mulResponse = new CalculatorService.MultiplyResponse_element();
                mulResponse.MultiplyResult = 18;
                response.put('response_x', mulResponse);
            }
            when 'DIV_MODE' {
                CalculatorService.DivideResponse_element divResponse = new CalculatorService.DivideResponse_element();
                divResponse.DivideResult = 2;
                response.put('response_x', divResponse);
            }
        }
    }

}
