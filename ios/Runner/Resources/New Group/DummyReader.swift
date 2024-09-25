//
//  DummyReader.swift
//  Gramedia Digital
//
//  Created by Gramedia on 08/03/23.
//

import Foundation
import ColibrioReader

struct ListDataReader {
        let dataTheme:[PublicationStylePalette?] = [nil,
                                                        PublicationStylePalette(accent: "#d48872", backgroundDark: "#424242", backgroundLight: "#303030", foregroundDark: "#ffffff", foregroundLight: "#ffffffb3"),PublicationStylePalette(accent:"#FF6E31",backgroundDark:"#CFB997",backgroundLight:"#F9F5E7",foregroundDark:"#AA5656",foregroundLight:"#A7727D")
                                                        ]
    
        let dataFontFamily:[FontFamilyStyle] = [FontFamilyStyle(fontFamily: "Default", fontSet: PublicationStyleFontSet(defaults: .init(fallback: "Nunito"), fontFaces: [PublicationStyleFontFace(family: "Nunito", mediaType: .fontTtf, src: "Nunito-Medium.ttf")]), fontAsset: "Nunito"),FontFamilyStyle(fontFamily: "Roboto", fontSet: PublicationStyleFontSet(defaults: .init(fallback: "Roboto"), fontFaces: [PublicationStyleFontFace(family: "Roboto", mediaType: .fontTtf, src: "Roboto-Regular.ttf")]), fontAsset: "Helvetica"),FontFamilyStyle(fontFamily: "Georgia", fontSet: PublicationStyleFontSet(defaults: .init(fallback: "Georgia"), fontFaces: [PublicationStyleFontFace(family: "Georiga", mediaType: .fontTtf, src: "georgia.ttf")]), fontAsset: "Georgia"),FontFamilyStyle(fontFamily: "Times New Roman", fontSet: PublicationStyleFontSet(defaults: .init(fallback: "Tinos"), fontFaces: [PublicationStyleFontFace(family: "Tinos", mediaType: .fontTtf, src: "Tinos-Regular.ttf")]), fontAsset: "Times New Roman"),FontFamilyStyle(fontFamily: "Open Sans", fontSet: PublicationStyleFontSet(defaults: .init(fallback: "OpenSans"), fontFaces: [
                PublicationStyleFontFace(family: "OpenSans", mediaType: .fontTtf, src: "OpenSans-Regular.ttf")]), fontAsset: "OpenSans"),FontFamilyStyle(fontFamily: "Merriweather", fontSet: PublicationStyleFontSet(defaults: .init(fallback: "Merriweather"), fontFaces: [PublicationStyleFontFace(family: "Merriweather", mediaType: .fontTtf, src: "Merriweather-Regular.ttf")]), fontAsset: "Merriweather"),FontFamilyStyle(fontFamily: "Vollkorn", fontSet: PublicationStyleFontSet(defaults: .init(fallback: "Vollkorn"), fontFaces: [PublicationStyleFontFace(family: "Vollkorn", mediaType: .fontTtf, src: "Vollkorn-VariableFont_wght.ttf")]), fontAsset: "Vollkorn")
                                                    ]
    
        let dataSwipeDirection:[ColibrioReader.Renderer] = [
                SinglePageSwipeRenderer(with: SinglePageSwipeRendererOptions(ignoreAspectRatio: true)),
                SpreadSwipeRenderer(with:SpreadSwipeRendererOptions(ignoreAspectRatio: true)),
                SingleDocumentScrollRenderer(with: SingleDocumentScrollRendererOptions(ignoreAspectRatio: true))
            ]
    
        let dataAlignment:[ColibrioReader.PublicationStyleTextAlignmentOptions?] = [nil,
                                                                                            .init(preserved: [.left,.justify], defaultAlignment: .left),
                                                                                            nil
                                                                                        ]
}
