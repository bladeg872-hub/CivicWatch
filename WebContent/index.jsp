<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>CivicWatch - Public Infrastructure Transparency Hub</title>
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/style.css">
    <style>
        .hero {
            min-height: calc(100vh - 72px);
            display: grid;
            grid-template-columns: 1.1fr 0.9fr;
            gap: 48px;
            padding: 48px 64px;
            align-items: center;
            background: radial-gradient(1200px circle at top left, #E0E7FF 0%, transparent 55%);
        }
        h1 {
            font-size: clamp(36px, 4vw, 54px);
            line-height: 1.1;
            margin-bottom: 20px;
            font-weight: 800;
            letter-spacing: -0.03em;
        }
        .subtitle {
            font-size: 18px;
            color: var(--text-muted);
            max-width: 520px;
            margin-bottom: 32px;
        }
        .cta-group {
            display: flex;
            gap: 16px;
            margin-bottom: 48px;
        }
        .features {
            display: grid;
            grid-template-columns: repeat(2, minmax(0, 1fr));
            gap: 20px;
        }
        .feature-card {
            background: white;
            padding: 24px;
            border-radius: var(--radius);
            box-shadow: var(--shadow);
            border: 1px solid var(--border-soft);
        }
        .feature-card h3 {
            font-size: 16px;
            margin-bottom: 8px;
            font-weight: 700;
        }
        .feature-card p {
            font-size: 14px;
            color: var(--text-muted);
        }
        .hero-image {
            position: relative;
        }
        .image-wrap {
            border-radius: var(--radius-lg);
            overflow: hidden;
            box-shadow: var(--shadow-lg);
            background: var(--brand-secondary);
        }
        .image-wrap img {
            width: 100%;
            height: 600px;
            object-fit: cover;
            display: block;
        }
        .image-caption {
            position: absolute;
            left: 24px;
            bottom: 24px;
            background: rgba(15, 23, 42, 0.85);
            backdrop-filter: blur(8px);
            color: white;
            padding: 12px 16px;
            border-radius: 12px;
            font-size: 12px;
            max-width: 80%;
        }
        .image-caption a { color: var(--brand-accent); text-decoration: none; font-weight: 700; }
        @media (max-width: 980px) {
            .hero { grid-template-columns: 1fr; padding: 32px 24px; }
            .image-wrap img { height: 400px; }
            .features { grid-template-columns: 1fr; }
        }
    </style>
</head>
<body>
    <jsp:include page="/jsp/includes/navbar.jsp" />

    <section class="hero">
        <div>
            <h1>Make infrastructure issues visible, trackable, and solved.</h1>
            <p class="subtitle">
                CivicWatch lets residents report road damage, lighting failures, sanitation issues, and more. Coordinators track progress, prioritize fixes, and communicate status - building transparency and trust.
            </p>
            <div class="cta-group">
                <a class="btn btn-primary" href="<%= request.getContextPath() %>/jsp/login.jsp">Get Started</a>
                <a class="btn btn-ghost" href="<%= request.getContextPath() %>/jsp/about-us.jsp">Learn More</a>
            </div>
            <div class="features">
                <div class="feature-card">
                    <h3>Report with evidence</h3>
                    <p>Submit photos, locations, and clear descriptions to speed up resolution.</p>
                </div>
                <div class="feature-card">
                    <h3>Transparent status</h3>
                    <p>Track each report from Pending to Resolved with full history.</p>
                </div>
                <div class="feature-card">
                    <h3>Community impact</h3>
                    <p>Prioritize urgent issues and measure progress across districts.</p>
                </div>
                <div class="feature-card">
                    <h3>Role-based dashboards</h3>
                    <p>Residents, coordinators, and admins get tailored workflows.</p>
                </div>
            </div>
        </div>
        <div class="hero-image">
            <div class="image-wrap">
                <img src="<%= request.getContextPath() %>/images/hero-street.jpg" alt="City street infrastructure">
            </div>
            <div class="image-caption">
                Photo: "Kanatna Street" by Yuriy Kvach - <a href="https://commons.wikimedia.org/wiki/File:Kanatna_Street.jpg">CC BY-SA 4.0</a>
            </div>
        </div>
    </section>
</body>
</html>
