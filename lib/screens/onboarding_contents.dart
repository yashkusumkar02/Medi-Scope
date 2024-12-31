class OnboardingContents {
  final String title;
  final String image;
  final String desc;

  OnboardingContents({
    required this.title,
    required this.image,
    required this.desc,
  });
}

List<OnboardingContents> contents = [
  OnboardingContents(
    title: "Introducing MediScope",
    image: "assets/images/image1.png",
    desc: "MediScope is a powerful health companion app designed to help you detect and monitor serious health conditions like cancer, brain tumors, and heart disease. With our advanced technology, you can get accurate results from your images and take control of your health anytime, anywhere.",
  ),
  OnboardingContents(
    title: "Accurate Disease Detection",
    image: "assets/images/image2.png",
    desc:
        "Using state-of-the-art machine learning and AI, MediScope analyzes medical images to detect signs of disease such as breast cancer, lung cancer, and more. Our goal is to give you peace of mind and help you make informed health decisions.",
  ),
  OnboardingContents(
    title: "Your Health, Our Priority",
    image: "assets/images/image3.png",
    desc:
        "MediScope is not just an app – it’s your personal health assistant. Our app helps you monitor and detect health issues early, empowering you to take timely actions for a healthier life. Get started today and take the first step towards a better future.",
  ),
];
