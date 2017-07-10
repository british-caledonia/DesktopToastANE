/*@copyright The code is licensed under the[MIT
 License](http://opensource.org/licenses/MIT):
 
 Copyright © 2017 -  Tua Rua Ltd.
 
 Permission is hereby granted, free of charge, to any person obtaining a copy
 of this software and associated documentation files(the "Software"), to deal
 in the Software without restriction, including without limitation the rights
 to use, copy, modify, merge, publish, distribute, sublicense, and / or sell
 copies of the Software, and to permit persons to whom the Software is
 furnished to do so, subject to the following conditions :
 
 The above copyright notice and this permission notice shall be included in
 all copies or substantial portions of the Software.
 
 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.IN NO EVENT SHALL THE
 AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
 SOFTWARE.*/

#import <Foundation/Foundation.h>
#include "DesktopToastANE_oc.h"
#import "DesktopToastANE-Swift.h"
#import <FreSwift/FlashRuntimeExtensions.h>

SwiftController *swft;
NSArray * funcArray;
#define FRE_FUNCTION(fn) FREObject (fn)(FREContext context, void* functionData, uint32_t argc, FREObject argv[])

FRE_FUNCTION(callSwiftFunction) {
    NSString* fName = (__bridge NSString *)(functionData);
    return [swft callSwiftFunctionWithName:fName ctx:context argc:argc argv:argv];
}

void TRDTT_contextInitializer(void *extData, const uint8_t *ctxType, FREContext ctx, uint32_t *numFunctionsToSet,
                        const FRENamedFunction **functionsToSet) {
    
    swft = [[SwiftController alloc] init];
    [swft setFREContextWithCtx:ctx];
    funcArray = [swft getFunctions];
    
    /**************************************************************************/
    /********************* DO NO MODIFY ABOVE THIS LINE ***********************/
    /**************************************************************************/
    
    /******* MAKE SURE TO ADD FUNCTIONS HERE THE SAME AS SWIFT CONTROLLER *****/
    /**************************************************************************/
    static FRENamedFunction extensionFunctions[] =
    {
        { (const uint8_t*) "init", (__bridge void *)@"init", &callSwiftFunction }
        ,{ (const uint8_t*) "show", (__bridge void *)@"show", &callSwiftFunction }
        ,{ (const uint8_t*) "getNamespace", (__bridge void *)@"getNamespace", &callSwiftFunction }
    };
    /**************************************************************************/
    /**************************************************************************/
    
    
    *numFunctionsToSet = sizeof(extensionFunctions) / sizeof(FRENamedFunction);
    *functionsToSet = extensionFunctions;
    
}

void TRDTT_contextFinalizer(FREContext ctx) {
    return;
}


void TRDTTExtInizer(void **extData, FREContextInitializer *ctxInitializer, FREContextFinalizer *ctxFinalizer) {
    *ctxInitializer = &TRDTT_contextInitializer;
    *ctxFinalizer = &TRDTT_contextFinalizer;
}

void TRDTTExtFinizer(void *extData) {
    FREContext nullCTX;
    nullCTX = 0;
    TRDTT_contextFinalizer(nullCTX);
    return;
}
