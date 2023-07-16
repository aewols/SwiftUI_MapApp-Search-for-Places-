//
//  Location.swift
//  MapRoutes
//
//  Created by 이연정 on 2023/07/14.
//

//import SwiftUI
//import MapKit
//
//struct Location: View {
//    @State private var distance: String?
//    let searchResult: MKLocalSearchCompletion
//    @ObservedObject var locVM: LocationManager
//
//    var body: some View {
//        VStack {
//            HStack {
//                Image(systemName: "pin")
//                VStack(alignment: .leading, spacing: 10) {
//                    Text(searchResult.title)
//                    Text(searchResult.subtitle)
//                    if let distance = distance {
//                        Text(distance)
//                    }
//                }
//               
//            }.task {
//                locVM.getDistance(searchResult: searchResult) { value in
//                    self.distance = value
//                }
//            }
//            
//        }
//        
//    }
//}
//
//struct SearchCompleter: View {
//    @ObservedObject var locVM: LocationManager
//    @Environment(\.dismiss) var dismiss
//    
//    var body: some View {
//        NavigationView {
//            VStack {
//                TextField("Search..", text: $locVM.search)
//                    .textFieldStyle(.roundedBorder)
//                List(locVM.searchResults,id: \.self) {res in
//                    VStack(alignment: .leading, spacing: 0) {
//                        SearchCompleterLabelView(searchResult: res, locVM: locVM)
//                    }
//                    .onTapGesture {
//                        locVM.name = res.title
//                        locVM.reverseUpdate()
//                        dismiss()
//                    }
//                }
//            }.padding()
//                .navigationTitle(Text("Search For Place"))
//        }
//    }
//}
//
//
//class LocationManager: NSObject, ObservableObject, CLLocationManagerDelegate, MKLocalSearchCompleterDelegate {
//    let manager = CLLocationManager()
//    @Published var region: MKCoordinateRegion
//    @Published var location: CLLocationCoordinate2D?
//    @Published var name: String = ""
//    @Published var search: String = ""
//
//    @Published var searchResults = [MKLocalSearchCompletion]()
//    var publisher: AnyCancellable?
//    var searchCompleter = MKLocalSearchCompleter()
//
//    override init() {
//        let latitude = 0
//        let longitude = 0
//        self.region = MKCoordinateRegion(center:CLLocationCoordinate2D(latitude:
//                                                                        CLLocationDegrees(latitude), longitude: CLLocationDegrees(longitude)), span:
//                                            MKCoordinateSpan(latitudeDelta: 0.25, longitudeDelta: 0.25))
//        super.init()
//        manager.delegate = self
//        searchCompleter.delegate = self
//
//        self.publisher = $search.receive(on: RunLoop.main).sink(receiveValue: { [weak self] (str) in
//            self?.searchCompleter.queryFragment = str
//        })
//    }
//    
//
//    func requestLocation() {
//        manager.requestLocation()
//    }
//    func completerDidUpdateResults(_ completer: MKLocalSearchCompleter) {
//        searchResults = completer.results
//        
//    }
//    
//    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
//        location = locations.first?.coordinate
//    }
//   
//    func getDistance(searchResult: MKLocalSearchCompletion, completionHandler: @escaping (String) -> ()) {
//      let searchRequest = MKLocalSearch.Request(completion: searchResult)
//      let search = MKLocalSearch(request: searchRequest)
//      var placeMarkCoordinates: CLLocation = CLLocation(latitude: 0, longitude: 0)
//      search.start { (response, error) in
//        guard let coordinate = response?.mapItems[0].placemark.coordinate else {
//          return
//        }
//
//        placeMarkCoordinates = CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)
//          let targetloc = CLLocation(latitude: self.location?.latitude ?? 0, longitude: self.location?.longitude ?? 0)
//          completionHandler("\(String(format: " Distance : %.2f ",targetloc.distance(from: placeMarkCoordinates).toKilometers())) KM")
//      }
//    }
//    
//    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
//         print("error:: \(error.localizedDescription)")
//    }
//    
//}
//extension CLLocationDistance {
//    func toMiles() -> CLLocationDistance {
//        return self*0.00062137
//    }
//
//    func toKilometers() -> CLLocationDistance {
//        return self/1000
//    }
//}
//
