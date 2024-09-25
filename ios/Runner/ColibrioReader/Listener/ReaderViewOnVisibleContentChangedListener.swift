//
//  ReaderListener.swift
//  SCOOP
//
//  Created by Gramedia on 23/08/22.
//

import UIKit
import ColibrioReader

protocol ChangedPageDelegate{
    func changePage(page:SimpleLocatorData, index:Int)
}


final class ReaderViewOnVisibleContentChangedListener: OnVisibleContentChangedListener {
    private var latestVisibleRange: String?
    private let contentPositionTimelineSlider: UISlider
    var delegate:ChangedPageDelegate?
    var contentPositionTimeline: ContentPositionTimeline?

    init(contentPositionTimelineSlider: UISlider,delegate:ChangedPageDelegate) {
        self.contentPositionTimelineSlider = contentPositionTimelineSlider
        self.delegate = delegate
    }

    func onVisiblePagesChanged(visiblePages: [VisiblePageData]) {
        
    }

    func onVisibleRangeChanged(visibleRange: SimpleLocatorData?) {
        guard let visibleRange = visibleRange,
              let contentPositionTimeline = contentPositionTimeline else {
            // No document loaded or timeline not set, hide slider
            latestVisibleRange = nil
            contentPositionTimelineSlider.isHidden = true
            return
        }
        
        // Store the latest visible range
        latestVisibleRange = visibleRange.selectors.first

        contentPositionTimeline.fetchTimelineRange(locator: visibleRange) { [weak self] result in
            switch result {
            case .success(let integerRange):
                guard let self = self else {
                    break
                }

                if visibleRange.selectors.first != self.latestVisibleRange {
                    // Ignore this range if it's not the latest
                    break
                }
                self.delegate?.changePage(page: visibleRange, index: integerRange.end)
                self.updateSlider(integerRange: integerRange)
            case .failure(let error):
                logToConsole(error.message)
            }
        }
    }

    private func updateSlider(integerRange: IntegerRange) {
        // Show position slider
        contentPositionTimelineSlider.isHidden = false

        if integerRange.start == 0 {
            // If range is between 0 and something else, snap slider to start position
            contentPositionTimelineSlider.value = 0
            return
        }

        if Float(integerRange.start)...Float(integerRange.end) ~= contentPositionTimelineSlider.value {
            // If current slider position is within this range, do nothing
            return
        }

        // Otherwise snap slider to range end
        print("Slider \(integerRange.end)")
        
        contentPositionTimelineSlider.value = Float(integerRange.end)
        
    }
}

