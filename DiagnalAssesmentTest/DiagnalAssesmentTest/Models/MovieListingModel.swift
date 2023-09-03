//
//  MovieListingModel.swift
//  DiagnalAssesmentTest
//
//  Created by Ahmed Abbas on 31/08/23.
//

import Foundation

struct MovieListingResponse: Codable {
    
    var page : Page? = Page()
    
    enum CodingKeys: String, CodingKey {
        
        case page = "page"
        
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        
        page = try values.decodeIfPresent(Page.self , forKey: .page )
        
    }
    
    init() {
        
    }
    
}

struct Page: Codable {
    
    var title               : String?        = nil
    var totalContentItems   : String?        = nil
    var pageNum             : String?        = nil
    var pageSize            : Int?           = nil
    var contentItems        : ContentItems? = ContentItems()
    
    enum CodingKeys: String, CodingKey {
        
        case title               = "title"
        case totalContentItems = "total-content-items"
        case pageNum            = "page-num"
        case pageSize           = "page-size"
        case contentItems       = "content-items"
        
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        
        title              = try values.decodeIfPresent(String.self        , forKey: .title              )
        totalContentItems  = try values.decodeIfPresent(String.self        , forKey: .totalContentItems  )
        pageNum            = try values.decodeIfPresent(String.self        , forKey: .pageNum            )
        contentItems       = try values.decodeIfPresent(ContentItems.self  , forKey: .contentItems       )

        if let stringVal = try values.decodeIfPresent(String.self, forKey: .pageSize), let intVal = Int(stringVal) {
            pageSize = intVal
        } else {
            pageSize = 0
        }
        
    }
    
    init() {
        
    }
    
}

struct Content: Codable {
    
    var name         : String? = nil
    var posterImage  : String? = nil
    
    enum CodingKeys: String, CodingKey {
        
        case name         = "name"
        case posterImage  = "poster-image"
        
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        
        name         = try values.decodeIfPresent(String.self , forKey: .name        )
        posterImage  = try values.decodeIfPresent(String.self , forKey: .posterImage )
        
    }
    
    init() {
        
    }
    
}


struct ContentItems: Codable {
    
    var content : [Content]? = []
    
    enum CodingKeys: String, CodingKey {
        
        case content = "content"
        
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        
        content = try values.decodeIfPresent([Content].self , forKey: .content )
        
    }
    
    init() {
        
    }
    
}

