//
//  SplashVM.swift
//  WMooive
//
//  Created by Halit Baskurt on 18.06.2024.
//

import Foundation
import WMovieAPI


protocol SplashVM {
    var stateClosure:( (ObservationType<SplashVMImpl.Event, SplashVMImpl.ErrorType>) -> () )? { get set }
}

final class SplashVMImpl : SplashVM {
    var stateClosure: ((ObservationType<SplashEvent, ErrorType>) -> ())?
    
    
    typealias Event = SplashEvent
    typealias ErrorType = Error
    
    init() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) { [weak self] in
            self?.stateClosure?(.updateUI(.userAuthenticated))
        }
    }
    deinit { debugPrint("DEINIT \(self)") }
    
    enum SplashEvent {
        case userAuthenticated
    }
}
