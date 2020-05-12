//
//  GCProgressView.swift
//  
//
//  Created by Gray Campbell on 5/11/20.
//

import SwiftUI

/// A view that depicts the progress of a task over time.

public struct GCProgressView: View {
    
    /// The progress view style.
    
    public let style: GCProgressView.Style
    
    /// The current progress shown by the progress view.
    ///
    /// The current progress is represented by a `Double` value between 0.0 and 1.0, inclusive, where 1.0 indicates the completion of the task. Values less than 0.0 and greater than 1.0 are pinned to those limits.
    
    @Binding public var progress: Double
    
    private var adjustedProgress: Double {
        min(max(0, self.progress), 1)
    }
    
    public var body: some View {
        GeometryReader { geometry in
            if self.style == .bar {
                GCProgressBar(progress: self.adjustedProgress)
                    .stroke(style: self.barStrokeStyle(geometry))
                    .background(
                        GCProgressBar(progress: 1)
                            .stroke(style: self.barStrokeStyle(geometry))
                            .foregroundColor(Color(.systemFill))
                    )
                    .padding(.horizontal, self.barPadding(geometry))
            }
            else if self.style == .circle {
                GCProgressCircle(progress: self.adjustedProgress)
                    .fill()
            }
            else {
                GCProgressRing(progress: self.adjustedProgress)
                    .stroke(style: self.ringStrokeStyle(geometry))
                    .padding(self.ringPadding(geometry))
            }
        }
        .animation(.linear)
    }
}

// MARK: - Padding, Line Width, & Stroke Style

extension GCProgressView {
    
    // MARK: Bar
    
    private func barPadding(_ geometry: GeometryProxy) -> CGFloat {
        self.barLineWidth(geometry) / 2
    }
    
    private func barLineWidth(_ geometry: GeometryProxy) -> CGFloat {
        min(geometry.size.width / 8, geometry.size.height)
    }
    
    private func barStrokeStyle(_ geometry: GeometryProxy) -> StrokeStyle {
        StrokeStyle(lineWidth: self.barLineWidth(geometry), lineCap: .round)
    }
    
    // MARK: Ring
    
    private func ringPadding(_ geometry: GeometryProxy) -> CGFloat {
        self.ringLineWidth(geometry) / 2
    }
    
    private func ringLineWidth(_ geometry: GeometryProxy) -> CGFloat {
        let smallestDimension = min(geometry.size.width, geometry.size.height)
        
        return max(smallestDimension / 8, 1)
    }
    
    private func ringStrokeStyle(_ geometry: GeometryProxy) -> StrokeStyle {
        StrokeStyle(lineWidth: self.ringLineWidth(geometry), lineCap: .round)
    }
}