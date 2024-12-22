import SwiftUI

struct ParticleBackgroundView: View {
    @State private var particles: [Particle] = []
    
    struct Particle: Identifiable {
        let id = UUID()
        var position: CGPoint
        var size: CGFloat
        var opacity: Double
        var speed: Double
    }
    
    var body: some View {
        TimelineView(.animation) { timeline in
            Canvas { context, size in
                for particle in particles {
                    context.opacity = particle.opacity
                    context.fill(
                        Path(ellipseIn: CGRect(
                            x: particle.position.x,
                            y: particle.position.y,
                            width: particle.size,
                            height: particle.size
                        )),
                        with: .color(.white)
                    )
                }
            }
            .onChange(of: timeline.date) { _ in
                updateParticles()
            }
            .onAppear {
                createParticles()
            }
        }
    }
    
    private func createParticles() {
        for _ in 0..<50 {
            particles.append(
                Particle(
                    position: CGPoint(
                        x: CGFloat.random(in: 0...UIScreen.main.bounds.width),
                        y: CGFloat.random(in: 0...UIScreen.main.bounds.height)
                    ),
                    size: CGFloat.random(in: 2...6),
                    opacity: Double.random(in: 0.1...0.5),
                    speed: Double.random(in: 0.5...2)
                )
            )
        }
    }
    
    private func updateParticles() {
        for i in particles.indices {
            particles[i].position.y -= particles[i].speed
            
            if particles[i].position.y < -10 {
                particles[i].position.y = UIScreen.main.bounds.height + 10
                particles[i].position.x = CGFloat.random(in: 0...UIScreen.main.bounds.width)
            }
        }
    }
}
