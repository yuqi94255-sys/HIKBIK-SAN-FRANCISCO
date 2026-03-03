import SwiftUI
import MapKit

struct ParkDetailView: View {
    let park: Park
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                if let url = URL(string: park.image) {
                    AsyncImage(url: url) { phase in
                        switch phase {
                        case .success(let image): image.resizable().scaledToFill()
                        case .failure: Image(systemName: "photo").foregroundStyle(Color.hikbikMutedForeground)
                        default: ProgressView()
                        }
                    }
                    .frame(height: 200)
                    .clipped()
                    .clipShape(RoundedRectangle(cornerRadius: HikBikRadius.lg))
                }
                
                VStack(alignment: .leading, spacing: HikBikSpacing.sm) {
                    Text(park.name)
                        .font(HikBikFont.titleLarge())
                        .foregroundStyle(Color.hikbikPrimary)
                    Text(park.description)
                        .font(HikBikFont.body())
                        .foregroundStyle(Color.hikbikForeground)
                    
                    if !park.activities.isEmpty {
                        Text("活动")
                            .font(HikBikFont.headline())
                            .foregroundStyle(Color.hikbikPrimary)
                        FlowLayout(spacing: HikBikSpacing.sm) {
                            ForEach(park.activities, id: \.self) { a in
                                Text(a)
                                    .font(HikBikFont.caption())
                                    .padding(.horizontal, HikBikSpacing.sm)
                                    .padding(.vertical, HikBikSpacing.xs)
                                    .background(Color.hikbikTabActiveTint)
                                    .foregroundStyle(Color.hikbikTabActive)
                                    .clipShape(Capsule())
                            }
                        }
                    }
                    
                    if let hours = park.hours { Label(hours, systemImage: "clock").foregroundStyle(Color.hikbikForeground) }
                    if let fee = park.entryFee { Label(fee, systemImage: "dollarsign").foregroundStyle(Color.hikbikForeground) }
                    if let phone = park.phone { Label(phone, systemImage: "phone").foregroundStyle(Color.hikbikForeground) }
                    if let url = park.websiteUrl, let u = URL(string: url) {
                        Link(destination: u) { Label("官网", systemImage: "link").foregroundStyle(Color.hikbikTabActive) }
                    }
                }
                .padding(.horizontal)
                
                Map(initialPosition: .region(MKCoordinateRegion(
                    center: CLLocationCoordinate2D(latitude: park.latitude, longitude: park.longitude),
                    span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
                ))) {
                    Marker(park.name, coordinate: CLLocationCoordinate2D(latitude: park.latitude, longitude: park.longitude))
                }
                .frame(height: 200)
                .clipShape(RoundedRectangle(cornerRadius: HikBikRadius.lg))
            }
        }
        .background(Color.hikbikBackground)
        .navigationTitle(park.name)
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    NavigationStack {
        ParkDetailView(park: Park(
            id: 1, name: "示例公园", description: "描述", image: "https://images.unsplash.com/photo-1501594907352-04cda38ebc29?w=400",
            activities: ["Hiking", "Camping"], latitude: 37.5, longitude: -122, popularity: 8,
            hours: "8–6", entryFee: "$10", phone: nil, region: nil, county: nil, type: nil, camping: nil, websiteUrl: nil
        ))
    }
}
