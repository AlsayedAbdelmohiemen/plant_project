from icrawler.builtin import GoogleImageCrawler
import os

def download_images(keywords, base_dir, label, max_images=30):
    for keyword in keywords:
        folder_name = keyword.replace(" ", "_")
        save_path = os.path.join(base_dir, label, folder_name)

        # تخطي لو فيه صور كفاية
        if os.path.exists(save_path) and len(os.listdir(save_path)) >= 10:
            print(f"✅ {label} – {keyword} موجود بالفعل ({len(os.listdir(save_path))} صورة)، تم تخطيه.")
            continue

        # تحميل الصور
        print(f'📥 جاري تحميل صور: {label} – {keyword}')
        crawler = GoogleImageCrawler(storage={'root_dir': save_path})
        crawler.crawl(keyword=keyword, max_num=max_images)

        # التأكد من عدد الصور بعد التحميل
        downloaded = len(os.listdir(save_path)) if os.path.exists(save_path) else 0
        if downloaded == 0:
            print(f"⚠️ لم يتم تحميل صور لـ {keyword}")
        else:
            print(f"📸 تم تحميل {downloaded} صورة لـ {keyword}")

def count_images(base_dir, label):
    full_path = os.path.join(base_dir, label)
    print(f"\n📁 عدد الصور داخل {label.upper()}")
    print("-" * 50)

    if not os.path.exists(full_path):
        print(f"❌ المجلد {full_path} غير موجود.")
        return

    for folder in sorted(os.listdir(full_path)):
        folder_path = os.path.join(full_path, folder)
        if os.path.isdir(folder_path):
            num_images = len([
                f for f in os.listdir(folder_path)
                if os.path.isfile(os.path.join(folder_path, f)) and f.lower().endswith(('.jpg', '.jpeg', '.png'))
            ])
            warning = " ⚠️ (عدد قليل جدًا)" if num_images < 5 else ""
            print(f"{folder:<40}: {num_images} صورة{warning}")

# المسار الرئيسي
base_dir = 'plant_classifier_data'

# كلمات مفتاحية لفئة النبات (plant)
plant_keywords = [
    'healthy plant leaf', 'green plant leaf', 'damaged plant leaf',
    'leaf close up', 'plant leaf macro', 'leaf texture',
    'tomato leaf', 'apple leaf', 'grape leaf', 'potato leaf',
    'plant leaf with spots', 'plant leaf with disease',
    'leaf under sunlight', 'leaf macro photography',
    'leaf veins close up', 'leaf texture detail'
]

# كلمات مفتاحية لفئة not_plant (خضراء مضللة وقوية جدًا)
not_plant_keywords = [
    'green tshirt', 'plastic leaves', 'green background',
    'grass carpet', 'plastic plant decoration',
    'people wearing green clothes', 'green fabric texture',
    'green wall', 'artificial plants', 'green car',
    'kitchen green tiles', 'green lighting background',
    'green home decor', 'green street signs',

    # كلمات إضافية مضللة وقوية ضد الموديل
    'close up green fabric', 'green pillow pattern',
    'fake leaf decoration', 'green wall abstract texture',
    'green dress texture closeup', 'green rug with patterns',
    'artificial plant leaves close up', 'plastic plant pot',
    'green blurry photo', 'green background with texture',
    'green printed textile', 'green sofa close up',
    'green cardboard texture', 'green felt material',
    'green LED light reflection', 'green furniture decoration'
]

# تحميل الصور
download_images(plant_keywords, base_dir, 'plant')
download_images(not_plant_keywords, base_dir, 'not_plant')

# عرض إحصائيات بعد التحميل
count_images(base_dir, 'plant')
count_images(base_dir, 'not_plant')

print("\n✅ تم تحميل وتصنيف الصور بنجاح، وجاهزة للتدريب.")
