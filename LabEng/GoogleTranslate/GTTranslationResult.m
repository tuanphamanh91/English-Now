//
//  GTTranslationResult.m
//  GoogleTranslate
//

/*
 *  Copyright (c) 2014, Wayne Hartman
 *  All rights reserved.
 *
 *  Redistribution and use in source and binary forms, with or without
 *  modification, are permitted provided that the following conditions are met:
 *
 *  * Redistributions of source code must retain the above copyright notice, this
 *  list of conditions and the following disclaimer.
 *
 *  * Redistributions in binary form must reproduce the above copyright notice,
 *  this list of conditions and the following disclaimer in the documentation
 *  and/or other materials provided with the distribution.
 *
 *  * Neither the name of Wayne Hartman nor the names of its
 *  contributors may be used to endorse or promote products derived from
 *  this software without specific prior written permission.
 *
 *  THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
 *  AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
 *  IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
 *  DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE
 *  FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
 *  DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
 *  SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
 *  CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY,
 *  OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
 *  OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 */

#import "GTTranslationResult.h"

@implementation GTTranslationResult

#pragma mark - Initialization

- (instancetype)initWithText:(NSString *)text detectedLanguageCode:(NSString *)detectedLanguageCode {
    if ((self = [super init])) {
        _text = text;
        _detectedLanguageCode = detectedLanguageCode;
    }

    return self;
}

#pragma mark - Debug

- (NSString *)debugDescription {
    NSString *superDescription = [super debugDescription];
    
    return [NSString stringWithFormat:@"%@ Detected Language: %@ Translation: (%@)", superDescription, self.detectedLanguageCode, self.text];
}

- (NSString *)description {
    NSString *superDescription = [super description];
    
    return [NSString stringWithFormat:@"%@ Detected Language: %@ Translation: (%@)", superDescription, self.detectedLanguageCode, self.text];
}

@end
