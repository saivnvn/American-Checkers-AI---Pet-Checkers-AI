//NAMTH - Trinh Hai Nam (Saivnvn): Just vibe-coded Lotus Chess with AI — one weekend, one dream.
import SwiftUI

// MARK: 🌸 Lớp chính - Hồ Sen Động (Lotus Pond Deluxe Edition)
final class LotusPondView {
    /// Hàm tĩnh để gọi view hồ sen
    static func show(
        halfSpace: CGFloat,
        lotusCount: Int,
        onInfoButtonTapped: @escaping () -> Void,
        onOpenPGNButtonTapped: @escaping () -> Void
    ) -> some View {
        LotusPondScene(
            halfSpace: halfSpace,
            onInfoButtonTapped: onInfoButtonTapped,
            onOpenPGNButtonTapped: onOpenPGNButtonTapped,
            lotusCount: lotusCount
        )
    }

    // MARK: 🌊 View chính mô phỏng hồ sen
    private struct LotusPondScene: View {
        var halfSpace: CGFloat
        var onInfoButtonTapped: () -> Void
        var onOpenPGNButtonTapped: () -> Void // ✅ callback mới
        var lotusCount: Int
        
        // ⚙️ Tham số cấu hình
        private let lotusSize: CGFloat = 70.0
        private let fishWidth: CGFloat = 50.0
        private let fishHeight: CGFloat = 1.0
        private let lotusMaxBobbingAmplitude: CGFloat = 20.0
        private let fishInitialDepthOffset: CGFloat = 5.0
        private let fishMaxVerticalAmplitude: CGFloat = 5.0
        private let numberOfFloatingLotuses = 1
        private let numberOfFish = 0
        
        @State private var floatingLotusConfigs: [FloatingLotusConfig] = []
        @State private var fishConfigs: [FishConfig] = []


        var body: some View {
            GeometryReader { geo in
                ZStack {
                    // 🌊 Gradient nền mặt nước (ĐÃ CHỈNH SỬA - Màu chủ đạo: 495EAB)
                    LinearGradient(
                        gradient: Gradient(colors: [
                            // Darkest shade (Near bottom)
                            Color(red: 0.20, green: 0.25, blue: 0.47),
                            // Mid shade (Middle) - Tương đương #495EAB
                            Color(red: 0.286, green: 0.368, blue: 0.670),
                            // Lightest shade (Near top)
                            Color(red: 0.34, green: 0.44, blue: 0.80)
                        ]),
                        startPoint: .bottom,
                        endPoint: .top
                    )
                    .ignoresSafeArea()
                    
                    // 💫 Hiệu ứng ánh sáng phản chiếu chuyển động chậm
                    MovingLightReflection()
                        .blendMode(.screen)
                        .opacity(0.25)
                    
                    // 🌫️ Sóng động đa lớp (ĐÃ CHỈNH SỬA MÀU SẮC SÓNG)
                    BeautifulWaveLayer(
                        amplitude: 5,
                        speed: 0.3,
                        color: Color(red: 0.15, green: 0.20, blue: 0.35), // Darker blue base
                        opacity: 0.4,
                        halfSpace: geo.size.height
                    )
                        .blendMode(.multiply)
                        .offset(y: 15)
                    BeautifulWaveLayer(
                        amplitude: 8,
                        speed: 0.7,
                        color: Color.cyan, // Keep cyan for contrast/highlight
                        opacity: 0.15,
                        halfSpace: geo.size.height
                    )
                        .offset(y: 10)
                        .blendMode(.overlay)
                    BeautifulWaveLayer(
                        amplitude: 4,
                        speed: 1.0,
                        color: .white,
                        opacity: 0.08,
                        halfSpace: geo.size.height
                    )
                        .blendMode(.screen)
                    BeautifulWaveLayer(
                        amplitude: 2,
                        speed: 0.15,
                        color: Color(red: 0.25, green: 0.30, blue: 0.55), // Mid-tone blue
                        opacity: 0.3,
                        halfSpace: geo.size.height
                    )
                        .blendMode(.multiply)
                        .offset(y: 5)

                    // 🌸 Hoa sen trôi và phản chiếu
                    ForEach(floatingLotusConfigs.indices, id: \.self) { index in
                        FloatingLotus(
                            config: floatingLotusConfigs[index],
                            maxBobbingAmplitude: lotusMaxBobbingAmplitude,
                            viewWidth: geo.size.width
                        )
                        .frame(width: lotusSize, height: lotusSize)
                        .position(x: geo.size.width / 2, y: halfSpace * 0.3)
                        .shadow(color: .black.opacity(0.4), radius: 5, x: 0, y: 4)
                    }

                    // 🐠 bong hoa sen
                    ForEach(fishConfigs.indices, id: \.self) { index in
                        FloatingFish(
                            config: fishConfigs[index],
                            viewWidth: geo.size.width,
                            initialDepthOffset: fishInitialDepthOffset,
                            maxVerticalAmplitude: fishMaxVerticalAmplitude
                        )
                        .frame(width: fishWidth, height: fishHeight)
                        .position(x: geo.size.width / 2, y: halfSpace * 0.5)
                        .shadow(color: .black.opacity(0.2), radius: 3, x: 0, y: 2)
                    }
                }
                .frame(width: geo.size.width, height: geo.size.height)
                .clipped()
                .onAppear {
                    floatingLotusConfigs = (0..<lotusCount).map { _ in FloatingLotusConfig() }
                    fishConfigs = (0..<numberOfFish).map { _ in FishConfig() }
                }
                .onChange(of: lotusCount) { newValue in
                    withAnimation(.easeInOut(duration: 1.0)) {
                        floatingLotusConfigs = (0..<newValue).map { _ in FloatingLotusConfig() }
                    }
                }
            }
            .frame(height: halfSpace)
            
            // 🌸 Hai nút đối xứng hai bên mặt hồ
            .overlay(
                HStack {
                    // 📖 Nút mở ChessViewPGN (bên trái)
                    Button(action: {
                        
                        onOpenPGNButtonTapped()
                    }) {
                        Image(systemName: "book.fill")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 30, height: 30)
                            .foregroundColor(.white)
                            .shadow(color: .cyan.opacity(0.6), radius: 8, x: 0, y: 0)
                            .padding(.leading, 20)
                    }
                    .buttonStyle(.plain)
                    .zIndex(9999999)
                    
                    Spacer()
                    
                    // 🪷 Nút thông tin (bên phải)
                    Button(action: {
                        onInfoButtonTapped()
                    }) {
                        Image("thongtin")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 32, height: 32)
                            .shadow(color: .cyan.opacity(0.6), radius: 8, x: 0, y: 0)
                            .padding(.trailing, 20)
                    }
                    .buttonStyle(.plain)
                    .zIndex(9999999)
                }
                .frame(maxHeight: .infinity, alignment: .center)
            )
        }
    }

    // Không cần thay đổi struct này, nhưng lưu ý startFromLeft giờ sẽ bị bỏ qua
    private struct FloatingLotusConfig {
        let id = UUID()
        let bobbingDuration: Double = 5.0
        let rotationEffect: Double = Double.random(in: -5...5)
        let travelDuration: Double
        let startFromLeft: Bool = Bool.random() // Giá trị này sẽ bị bỏ qua

        init() {
            self.travelDuration = Double.random(in: 15...16)
        }
    }

    private struct FloatingLotus: View {
        let config: FloatingLotusConfig
        let maxBobbingAmplitude: CGFloat
        let viewWidth: CGFloat
        @State private var bobbingOffset: CGFloat = 0
        @State private var horizontalOffset: CGFloat = 0
        @State private var isMovingRight: Bool = false // <--- THÊM DÒNG NÀY
        
        var body: some View {
            ZStack {
                // 🌸 Bông hoa chính
                Image("lotus_flower")
                    .resizable()
                    .scaledToFit()
                    .scaleEffect(x: isMovingRight ? -1 : 1, y: 1) // <--- THAY ĐỔI Ở ĐÂY
                    .opacity(Double.random(in: 1.0...1.0))
                    .rotationEffect(.degrees(config.rotationEffect))
                    .offset(x: horizontalOffset, y: bobbingOffset)
                    .onAppear {
                        startBobbingAnimation()
                        startHorizontalDrift()
                    }
                
                // 🌊 Phản chiếu dưới mặt nước
                Image("conca")
                    .resizable()
                    .scaledToFit()
                    .scaleEffect(x: isMovingRight ? -1 : 1, y: -1) // <--- CHỈNH SỬA Ở ĐÂY
                    .opacity(0.25)
                    .blur(radius: 1)
                    .offset(x: horizontalOffset, y: bobbingOffset + 60)
            }
        }
        
        // MARK: - FloatingLotus (Thay thế hoàn toàn hàm này)
        private func startHorizontalDrift() {
            let offScreenPadding: CGFloat = 80
            let travelRange = (viewWidth / 2) + offScreenPadding
            
            // Khởi tạo ở bên trái hoặc phải tùy ý (ví dụ: luôn bắt đầu từ phải -> trái)
            let startX: CGFloat = travelRange // Bắt đầu từ phải
            let endX: CGFloat = -travelRange // Kết thúc ở trái
            
            horizontalOffset = startX
            isMovingRight = false // Bắt đầu di chuyển sang trái

            // Dùng .repeatForever(autoreverses: true) để tự động đảo chiều
            withAnimation(.linear(duration: config.travelDuration).repeatForever(autoreverses: true)) {
                horizontalOffset = endX // Di chuyển từ phải sang trái
            }
            
            // 💡 Logic lật hình ảnh khi đảo chiều:
            // Vì animation .repeatForever(autoreverses: true) không cung cấp callback
            // cho mỗi lần lặp, ta dùng một timer để đồng bộ việc lật hình ảnh.
            
            let halfDuration = config.travelDuration // Thời gian cho 1 chiều đi
            
            // Bắt đầu timer để lật hình ảnh sau mỗi nửa chu kỳ
            Timer.scheduledTimer(withTimeInterval: halfDuration, repeats: true) { _ in
                // Cứ sau mỗi halfDuration, hướng di chuyển sẽ đảo ngược
                withAnimation(.none) { // Không cần animation cho việc lật hình
                    isMovingRight.toggle()
                }
            }
        }
        
        private func startBobbingAnimation() {
            withAnimation(.linear(duration: config.bobbingDuration).repeatForever(autoreverses: true)) {
                bobbingOffset = maxBobbingAmplitude
            }
        }
   
    }

    // MARK: - 🐠 Cấu hình & View cho Cá
    private struct FishConfig {
        let id = UUID()
        let travelDuration: Double = Double.random(in: 20...30)
        let verticalBobbingDuration: Double = Double.random(in: 6...12)
    }

    private struct FloatingFish: View {
        let config: FishConfig
        let viewWidth: CGFloat
        let initialDepthOffset: CGFloat
        let maxVerticalAmplitude: CGFloat
        
        @State private var horizontalOffset: CGFloat = 0
        @State private var verticalOffset: CGFloat = 0

        var body: some View {
            Image("conca")
                .resizable()
                .scaledToFit()
                .scaleEffect(x: -1, y: 1)
                .offset(x: horizontalOffset, y: initialDepthOffset + verticalOffset)
                .opacity(Double(max(0.2, 1 - abs(horizontalOffset) / (viewWidth * 0.9))))
                .onAppear {
                    initializeAndStartMovement()
                }
        }

        private func initializeAndStartMovement() {
            let offScreenPadding: CGFloat = 50
            let startX = viewWidth / 2 + offScreenPadding
            let endX = -viewWidth / 2 - offScreenPadding
            horizontalOffset = startX
            
            func animateCycle() {
                withAnimation(.linear(duration: config.travelDuration)) {
                    horizontalOffset = endX
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + config.travelDuration) {
                    horizontalOffset = startX
                    animateCycle()
                }
            }
            animateCycle()
            withAnimation(.easeInOut(duration: config.verticalBobbingDuration).repeatForever(autoreverses: true)) {
                verticalOffset = -maxVerticalAmplitude
            }
        }
    }

    // MARK: 🌊 Sóng nước Canvas động
    private struct BeautifulWaveLayer: View {
        let amplitude: CGFloat
        let speed: Double
        let color: Color
        let opacity: Double
        let halfSpace: CGFloat

        var body: some View {
            TimelineView(.animation(minimumInterval: 1/60, paused: false)) { timeline in
                Canvas { context, size in
                    let time = timeline.date.timeIntervalSinceReferenceDate
                    let phase = CGFloat(time * speed).truncatingRemainder(dividingBy: 2 * .pi)
                    let baseHeight = halfSpace * 0.5

                    var path = Path()
                    path.move(to: CGPoint(x: 0, y: baseHeight))
                    for x in stride(from: 0, through: size.width, by: 4) {
                        let y = sin((x / size.width) * 4 * .pi + phase) * amplitude
                        path.addLine(to: CGPoint(x: x, y: baseHeight + y))
                    }
                    path.addLine(to: CGPoint(x: size.width, y: halfSpace))
                    path.addLine(to: CGPoint(x: 0, y: halfSpace))
                    path.closeSubpath()
                    context.fill(path, with: .color(color.opacity(opacity)))
                }
            }
        }
    }

    // MARK: ✨ Hiệu ứng ánh sáng chuyển động
    private struct MovingLightReflection: View {
        @State private var move = false
        var body: some View {
            LinearGradient(
                gradient: Gradient(colors: [
                    Color.white.opacity(0.0),
                    Color.white.opacity(0.25),
                    Color.white.opacity(0.0)
                ]),
                startPoint: .leading,
                endPoint: .trailing
            )
            .rotationEffect(.degrees(10))
            .offset(x: move ? 300 : -300)
            .animation(.linear(duration: 8).repeatForever(autoreverses: false), value: move)
            .onAppear { move = true }
        }
    }
}
