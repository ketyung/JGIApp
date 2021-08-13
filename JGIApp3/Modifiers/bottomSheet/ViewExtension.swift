/**
 Copyright (c) 2020 Tieda Wei

 Permission is hereby granted, free of charge, to any person obtaining a copy
 of this software and associated documentation files (the "Software"), to deal
 in the Software without restriction, including without limitation the rights
 to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 copies of the Software, and to permit persons to whom the Software is
 furnished to do so, subject to the following conditions:

 The above copyright notice and this permission notice shall be included in
 all copies or substantial portions of the Software.

 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 THE SOFTWARE.
 */
// Modified by Chee Ket Yung to suit requirement 24/04/2021.
//

import SwiftUI

public extension View {
    func bottomSheet<Content: View>(
        isPresented: Binding<Bool>,
        height: CGFloat, showGrayOverlay : Bool,
        topBarHeight: CGFloat = 30,
        topBarCornerRadius: CGFloat? = nil,
        contentBackgroundColor: Color = Color(.systemBackground),
        topBarBackgroundColor: Color = Color(.systemBackground),
        showTopIndicator: Bool = true,
        @ViewBuilder content: @escaping () -> Content
    ) -> some View {
        ZStack {
            self
            BottomSheet(isPresented: isPresented,
                        height: height,
                        topBarHeight: topBarHeight,
                        topBarCornerRadius: topBarCornerRadius,
                        topBarBackgroundColor: topBarBackgroundColor,
                        contentBackgroundColor: contentBackgroundColor,
                        showTopIndicator: showTopIndicator, showGrayOverlay : showGrayOverlay , 
                        content: content)
        }
    }
}
