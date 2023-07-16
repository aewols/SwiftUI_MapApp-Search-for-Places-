//
//  MapViewModel.swift
//  MapRoutes
//
//  Created by 이연정 on 2023/07/12.
//

import SwiftUI
import MapKit
import CoreLocation

// All Map Data Goes Here...

class MapViewModel: NSObject, ObservableObject, CLLocationManagerDelegate {
    
    @Published var mapView = MKMapView()
    // MKMapView 지도를 불러오는 함수
    // Published 속성을 게시하는 유형으로 값을 변화 혹은 업데이트 할 수 있음
    
    // Region...
    @Published var region : MKCoordinateRegion!
    // MKCoordinateRegion 특정 위도와 경도를 중심으로 한 직사각형 영역
    // Based On Location It Will Set Up...
    
    // Alert...
    @Published var permissionDenied = false
    
    // Map Type...
    @Published var mapType : MKMapType = .standard
    
    // SearchText...
    @Published var searchTxt = ""
    
    // Search Places...
    @Published var places : [Place] = []
    
    
    // Updating Map Type...
    func updateMapType() {
        
        if mapType == .standard {
            mapType = .hybrid
            mapView.mapType = mapType
        } else {
            mapType = .standard
            mapView.mapType = mapType
        }
    }
    
    
    // Focus Location...
    func focusLocation() {
        
        guard let _ = region else { return }
        
        mapView.setRegion(region, animated: true)
        // setRegion 보이는 영역을 변경하고 선택적으로 변경사항을 애니메이션화
        // region 지도보기에 표시할 새영역
        // 새 영역으로 전환을 애니메이션으로 만들 것인지 또는 맵이 지정된 영역의 중심에 즉시 배치되도록 할 것인지 지정
        
        mapView.setVisibleMapRect(mapView.visibleMapRect, animated: true)
        // 가장자리 주위에 추가 공간을 지정 지도에서 현재 보이는 부분을 변경
        // visibleMapRect 현재 지도 보기에서 표시되는 영역
        
    }
    
    
    // Search Places...
    func searchQuery() {
        
        places.removeAll()
        
        let request = MKLocalSearch.Request()
        // 지도 기반 검색을 시작하고 결과를 처리하기 위한 유틸리티 개체
        
        request.naturalLanguageQuery = searchTxt
        // naturalLanguageQuery 원하는 검색 항목을 포함하는 문자열
        
        // Fetch...
        MKLocalSearch(request: request).start { (response, _) in
        // map 검색창을 가져옴
            
            guard let result = response else { return }
            // 검색 텍스트 창에서 사용자가 원하는 부분을 선택하여 검색완료하면 그 장소를 가져옴
            
            self.places = result.mapItems.compactMap({ (item) -> Place? in
                return Place(place: item.placemark)
            })
        }
    }
    
    
    // Pick Search Result...
    func selectPlace(place: Place) {
        
        // Showing Pin On Map...
        
        searchTxt = ""
        
        guard let coordinate = place.place.location?.coordinate else { return }
        // coordinate 주석의 좌표점
        
        let pointAnnotation = MKPointAnnotation()
        // MKPointAnnotation 맵의 지점을 문자열로 가져오는 데이터
        
        pointAnnotation.coordinate = coordinate
        
        pointAnnotation.title = place.place.name ?? "No Name"
        // ??(Nil-coalescing operator) 어떤 값이 nil일 수 있는 상황일 때 nil 대신 다른 디폴트 값을 주고싶을 때 사용
        
        // Removing All Old Ones...
        mapView.removeAnnotations(mapView.annotations)      // 지정된 객체를 지도에서 제거
        mapView.addAnnotation(pointAnnotation)      // 지정된 객체를 지도에 추가
        
        // Moving Map To That Location...
        let coordinateRegion = MKCoordinateRegion(center: coordinate, latitudinalMeters: 10000, longitudinalMeters: 10000)
        // 지정된 좌표 및 거리 값으로 새 좌표 영역을 표시
        
        mapView.setRegion(coordinateRegion, animated: true)
        // setRegion 보이는 영역을 변경하고 선택적으로 변경사항을 애니메이션화
        // region 지도보기에 표시할 새영역
        // 새 영역으로 전환을 애니메이션으로 만들 것인지 또는 맵이 지정된 영역의 중심에 즉시 배치되도록 할 것인지 지정
        
        mapView.setVisibleMapRect(mapView.visibleMapRect, animated: true)
        // 가장자리 주위에 추가 공간을 지정 지도에서 현재 보이는 부분을 변경
        // visibleMapRect 현재 지도 보기에서 표시되는 영역
    }
    
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
    // CLLocationManager 앱으로 위치관련 이벤트 전달을 시작하고 중지하는데 사용
        
        // Checking Permissions...
        
        switch manager.authorizationStatus {
        case .denied:
            // Alert...
            permissionDenied.toggle()
        case .notDetermined:
            // Requesting...
            manager.requestWhenInUseAuthorization()
        case .authorizedWhenInUse:
            // If Permission Given...
            manager.requestLocation()
            // 사용자의 현재 위치를 일회성으로 전송요청
        default:
            ()
        }
        
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        
        // Error...
        print(error.localizedDescription)
    }
    
    
    // Getting user Region...
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        guard let location = locations.last else { return }
        
        self.region = MKCoordinateRegion(center: location.coordinate, latitudinalMeters: 10000, longitudinalMeters: 10000)
        
        // Updating Map...
        self.mapView.setRegion(self.region, animated: true)
        
        // Smooth Animations...
        self.mapView.setVisibleMapRect(self.mapView.visibleMapRect, animated: true)
    }
}
