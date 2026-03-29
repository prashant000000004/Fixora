package com.fixnow;

import com.fixnow.model.*;
import com.fixnow.repository.*;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.boot.CommandLineRunner;
import org.springframework.stereotype.Component;

import java.time.LocalDateTime;
import java.util.List;

@Component
public class DataSeeder implements CommandLineRunner {

    private static final Logger log = LoggerFactory.getLogger(DataSeeder.class);

    private final ServiceCategoryRepository categoryRepo;
    private final SubServiceRepository subServiceRepo;
    private final ServiceProviderRepository providerRepo;

    public DataSeeder(ServiceCategoryRepository categoryRepo,
            SubServiceRepository subServiceRepo,
            ServiceProviderRepository providerRepo) {
        this.categoryRepo = categoryRepo;
        this.subServiceRepo = subServiceRepo;
        this.providerRepo = providerRepo;
    }

    @Override
    public void run(String... args) {
        if (categoryRepo.count() > 0) {
            log.info("Database already seeded — skipping.");
            return;
        }

        log.info("Seeding database with demo data...");
        seedCategories();
        seedSubServices();
        seedProviders();
        log.info("Database seeding complete!");
    }

    private void seedCategories() {
        var categories = List.of(
                ServiceCategory.builder().id("electrical").name("Electrical").icon("electrical_services")
                        .color("0xFFD97706").startPrice(199).build(),
                ServiceCategory.builder().id("plumbing").name("Plumbing").icon("plumbing").color("0xFF0891B2")
                        .startPrice(249).build(),
                ServiceCategory.builder().id("carpentry").name("Carpentry").icon("carpenter").color("0xFFB45309")
                        .startPrice(299).build(),
                ServiceCategory.builder().id("cleaning").name("Cleaning").icon("cleaning_services").color("0xFF059669")
                        .startPrice(399).build(),
                ServiceCategory.builder().id("ac_repair").name("AC Repair").icon("ac_unit").color("0xFF2563EB")
                        .startPrice(499).build(),
                ServiceCategory.builder().id("painting").name("Painting").icon("format_paint").color("0xFF7C3AED")
                        .startPrice(999).build(),
                ServiceCategory.builder().id("pest_control").name("Pest Control").icon("pest_control")
                        .color("0xFFDC2626").startPrice(599).build(),
                ServiceCategory.builder().id("appliance").name("Appliance").icon("build").color("0xFF4338CA")
                        .startPrice(349).build());
        categoryRepo.saveAll(categories);
    }

    private void seedSubServices() {
        var electrical = categoryRepo.findById("electrical").orElseThrow();
        var plumbing = categoryRepo.findById("plumbing").orElseThrow();
        var carpentry = categoryRepo.findById("carpentry").orElseThrow();
        var cleaning = categoryRepo.findById("cleaning").orElseThrow();
        var acRepair = categoryRepo.findById("ac_repair").orElseThrow();
        var painting = categoryRepo.findById("painting").orElseThrow();

        var subServices = List.of(
                // Electrical
                SubService.builder().id("e1").name("Fan Installation")
                        .description("Ceiling/wall fan installation with wiring").minPrice(199).maxPrice(499)
                        .estimatedTime("30-60 min").avgRating(4.7).totalBookings(1240).category(electrical).build(),
                SubService.builder().id("e2").name("Wiring & Rewiring")
                        .description("New wiring, rewiring, or wiring repair").minPrice(399).maxPrice(1499)
                        .estimatedTime("1-3 hours").avgRating(4.6).totalBookings(890).category(electrical).build(),
                SubService.builder().id("e3").name("MCB/Fuse Repair")
                        .description("MCB replacement, fuse box repair, tripping fix").minPrice(149).maxPrice(599)
                        .estimatedTime("20-45 min").avgRating(4.8).totalBookings(2100).category(electrical).build(),
                SubService.builder().id("e4").name("Switch & Socket")
                        .description("Switch board repair, new socket installation").minPrice(99).maxPrice(349)
                        .estimatedTime("15-30 min").avgRating(4.7).totalBookings(3200).category(electrical).build(),
                SubService.builder().id("e5").name("Light Installation")
                        .description("LED light, chandelier, decorative light fitting").minPrice(199).maxPrice(799)
                        .estimatedTime("30-60 min").avgRating(4.5).totalBookings(1560).category(electrical).build(),
                SubService.builder().id("e6").name("Inverter/UPS")
                        .description("Inverter installation, UPS repair, battery replacement").minPrice(299)
                        .maxPrice(999).estimatedTime("45-90 min").avgRating(4.6).totalBookings(670).category(electrical)
                        .build(),
                // Plumbing
                SubService.builder().id("p1").name("Tap & Mixer")
                        .description("Tap repair, replacement, and new installation").minPrice(149).maxPrice(599)
                        .estimatedTime("20-45 min").avgRating(4.6).totalBookings(1890).category(plumbing).build(),
                SubService.builder().id("p2").name("Pipe Leakage")
                        .description("Pipe leak repair, joint fixing, pipe replacement").minPrice(249).maxPrice(999)
                        .estimatedTime("30-90 min").avgRating(4.7).totalBookings(2340).category(plumbing).build(),
                SubService.builder().id("p3").name("Drain Cleaning")
                        .description("Blocked drain, toilet unclogging, sewer cleaning").minPrice(299).maxPrice(799)
                        .estimatedTime("30-60 min").avgRating(4.5).totalBookings(1670).category(plumbing).build(),
                SubService.builder().id("p4").name("Toilet Repair")
                        .description("Flush repair, seat replacement, tank fixing").minPrice(199).maxPrice(699)
                        .estimatedTime("30-60 min").avgRating(4.6).totalBookings(1230).category(plumbing).build(),
                SubService.builder().id("p5").name("Water Tank")
                        .description("Tank cleaning, motor repair, pipeline installation").minPrice(499).maxPrice(1999)
                        .estimatedTime("1-3 hours").avgRating(4.4).totalBookings(560).category(plumbing).build(),
                // Carpentry
                SubService.builder().id("c1").name("Furniture Assembly")
                        .description("Bed, wardrobe, table, chair assembly").minPrice(299).maxPrice(799)
                        .estimatedTime("1-2 hours").avgRating(4.7).totalBookings(890).category(carpentry).build(),
                SubService.builder().id("c2").name("Door Repair")
                        .description("Door hinge, lock, handle repair or replacement").minPrice(199).maxPrice(599)
                        .estimatedTime("30-60 min").avgRating(4.6).totalBookings(1120).category(carpentry).build(),
                SubService.builder().id("c3").name("Custom Woodwork").description("Shelves, cabinets, custom furniture")
                        .minPrice(999).maxPrice(4999).estimatedTime("1-5 days").avgRating(4.8).totalBookings(340)
                        .category(carpentry).build(),
                // Cleaning
                SubService.builder().id("cl1").name("Full Home Cleaning").description("Deep clean for 1-3 BHK homes")
                        .minPrice(999).maxPrice(2999).estimatedTime("3-6 hours").avgRating(4.7).totalBookings(4560)
                        .category(cleaning).build(),
                SubService.builder().id("cl2").name("Kitchen Cleaning")
                        .description("Deep kitchen clean, chimney, appliance cleaning").minPrice(499).maxPrice(1299)
                        .estimatedTime("1-2 hours").avgRating(4.6).totalBookings(2340).category(cleaning).build(),
                SubService.builder().id("cl3").name("Bathroom Cleaning")
                        .description("Tile scrubbing, fixture cleaning, deep sanitize").minPrice(399).maxPrice(799)
                        .estimatedTime("1-2 hours").avgRating(4.5).totalBookings(1890).category(cleaning).build(),
                SubService.builder().id("cl4").name("Sofa Cleaning").description("Fabric & leather sofa deep cleaning")
                        .minPrice(599).maxPrice(1499).estimatedTime("1-2 hours").avgRating(4.8).totalBookings(1230)
                        .category(cleaning).build(),
                // AC Repair
                SubService.builder().id("ac1").name("AC Service")
                        .description("General service, filter cleaning, gas check").minPrice(399).maxPrice(799)
                        .estimatedTime("45-90 min").avgRating(4.7).totalBookings(5670).category(acRepair).build(),
                SubService.builder().id("ac2").name("AC Gas Refill").description("R22/R32/R410A gas refill")
                        .minPrice(1499).maxPrice(2999).estimatedTime("1-2 hours").avgRating(4.5).totalBookings(2340)
                        .category(acRepair).build(),
                SubService.builder().id("ac3").name("AC Installation")
                        .description("Split/window AC installation & uninstallation").minPrice(999).maxPrice(1999)
                        .estimatedTime("2-4 hours").avgRating(4.6).totalBookings(1560).category(acRepair).build(),
                SubService.builder().id("ac4").name("AC Repair").description("Compressor, PCB, fan motor repair")
                        .minPrice(799).maxPrice(3999).estimatedTime("1-3 hours").avgRating(4.4).totalBookings(1890)
                        .category(acRepair).build(),
                // Painting
                SubService.builder().id("pt1").name("1 Room Painting").description("Complete room painting with primer")
                        .minPrice(2999).maxPrice(5999).estimatedTime("1-2 days").avgRating(4.7).totalBookings(670)
                        .category(painting).build(),
                SubService.builder().id("pt2").name("Full Home Painting")
                        .description("Complete home painting with color consultation").minPrice(9999).maxPrice(29999)
                        .estimatedTime("3-7 days").avgRating(4.8).totalBookings(340).category(painting).build(),
                SubService.builder().id("pt3").name("Waterproofing")
                        .description("Wall, terrace, bathroom waterproofing").minPrice(1999).maxPrice(7999)
                        .estimatedTime("1-3 days").avgRating(4.5).totalBookings(450).category(painting).build());
        subServiceRepo.saveAll(subServices);
    }

    private void seedProviders() {
        var prov1 = ServiceProvider.builder()
                .id("prov1").name("Rahul Kumar").rating(4.8).totalReviews(234)
                .totalJobsCompleted(567).experienceYears(8).isVerified(true).isOnline(true)
                .distanceKm(1.2).skills(List.of("Electrician", "Wiring", "Fan Installation"))
                .aboutMe(
                        "Certified electrician with 8 years of experience. Specializing in residential wiring and smart home installations.")
                .build();
        providerRepo.save(prov1);

        var r1 = Review.builder().customerName("Amit S.").rating(5.0)
                .comment("Excellent work! Fixed my wiring issue in 30 minutes. Very professional.")
                .tags(List.of("Punctual", "Skilled", "Clean work")).createdAt(LocalDateTime.of(2026, 2, 15, 10, 0))
                .provider(prov1).build();
        var r2 = Review.builder().customerName("Priya M.").rating(4.5)
                .comment("Good work, arrived on time. Slightly expensive for the work done.")
                .tags(List.of("Punctual", "Skilled")).createdAt(LocalDateTime.of(2026, 2, 10, 14, 0)).provider(prov1)
                .build();
        var r3 = Review.builder().customerName("Rohit K.").rating(5.0)
                .comment("Best electrician I've ever hired. Installed 3 fans perfectly.")
                .tags(List.of("Skilled", "Clean work", "Friendly")).createdAt(LocalDateTime.of(2026, 1, 28, 16, 0))
                .provider(prov1).build();
        prov1.setReviews(List.of(r1, r2, r3));
        providerRepo.save(prov1);

        var prov2 = ServiceProvider.builder()
                .id("prov2").name("Suresh Mehta").rating(4.6).totalReviews(189)
                .totalJobsCompleted(423).experienceYears(12).isVerified(true).isOnline(true)
                .distanceKm(2.4).skills(List.of("Plumber", "Pipe Repair", "Water Tank"))
                .aboutMe("12 years experience in plumbing. Expert in leak detection and pipe repair.")
                .build();
        providerRepo.save(prov2);
        var r4 = Review.builder().customerName("Neha R.").rating(5.0)
                .comment("Fixed a nasty pipe leak that others couldn't. Highly recommend!")
                .tags(List.of("Skilled", "Experienced")).createdAt(LocalDateTime.of(2026, 2, 20, 11, 0)).provider(prov2)
                .build();
        var r5 = Review.builder().customerName("Vikash P.").rating(4.0)
                .comment("Good plumber, did the job well. A bit slow.").tags(List.of("Skilled"))
                .createdAt(LocalDateTime.of(2026, 2, 5, 9, 0)).provider(prov2).build();
        prov2.setReviews(List.of(r4, r5));
        providerRepo.save(prov2);

        var prov3 = ServiceProvider.builder()
                .id("prov3").name("Aman Singh").rating(4.9).totalReviews(312)
                .totalJobsCompleted(789).experienceYears(10).isVerified(true).isOnline(false)
                .distanceKm(0.8).skills(List.of("Carpenter", "Furniture", "Custom Woodwork"))
                .aboutMe("Master carpenter specializing in custom furniture and modular kitchens.")
                .build();
        providerRepo.save(prov3);
        var r6 = Review.builder().customerName("Sneha D.").rating(5.0)
                .comment("Built an amazing custom bookshelf. True craftsman!")
                .tags(List.of("Skilled", "Clean work", "Creative")).createdAt(LocalDateTime.of(2026, 2, 22, 15, 0))
                .provider(prov3).build();
        prov3.setReviews(List.of(r6));
        providerRepo.save(prov3);

        var prov4 = ServiceProvider.builder()
                .id("prov4").name("Priya Devi").rating(4.7).totalReviews(156)
                .totalJobsCompleted(345).experienceYears(5).isVerified(true).isOnline(true)
                .distanceKm(3.1).skills(List.of("Cleaner", "Deep Cleaning", "Kitchen Specialist"))
                .aboutMe("Professional cleaning expert. Making homes sparkle for 5 years!")
                .build();
        providerRepo.save(prov4);
        var r7 = Review.builder().customerName("Meera T.").rating(5.0)
                .comment("My kitchen has never looked this clean! Amazing attention to detail.")
                .tags(List.of("Punctual", "Clean work", "Thorough")).createdAt(LocalDateTime.of(2026, 2, 18, 12, 0))
                .provider(prov4).build();
        prov4.setReviews(List.of(r7));
        providerRepo.save(prov4);

        var prov5 = ServiceProvider.builder()
                .id("prov5").name("Vikash Patel").rating(4.5).totalReviews(98)
                .totalJobsCompleted(234).experienceYears(6).isVerified(true).isOnline(true)
                .distanceKm(1.5).skills(List.of("AC Technician", "AC Service", "Installation"))
                .aboutMe("Certified AC technician. Expert in all brands — Samsung, LG, Daikin, Voltas.")
                .build();
        providerRepo.save(prov5);
        var r8 = Review.builder().customerName("Rajesh G.").rating(4.5)
                .comment("AC is cooling much better after service. Good work!").tags(List.of("Skilled", "Punctual"))
                .createdAt(LocalDateTime.of(2026, 2, 12, 10, 0)).provider(prov5).build();
        prov5.setReviews(List.of(r8));
        providerRepo.save(prov5);

        var prov6 = ServiceProvider.builder()
                .id("prov6").name("Deepak Sharma").rating(4.8).totalReviews(267)
                .totalJobsCompleted(612).experienceYears(15).isVerified(true).isOnline(true)
                .distanceKm(2.0).skills(List.of("Painter", "Interior Design", "Waterproofing"))
                .aboutMe("15 years of painting experience. Color consultant & waterproofing expert.")
                .build();
        providerRepo.save(prov6);
    }
}
