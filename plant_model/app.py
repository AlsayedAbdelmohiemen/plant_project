import gdown
import io
import os
from PIL import Image
from flask import Flask, request, jsonify
from flask_cors import CORS
import tensorflow as tf
import numpy as np
from tensorflow.keras.preprocessing import image

app = Flask(__name__)
CORS(app)


# تحميل النموذج
model_path = "plant_disease_model.keras"
if not os.path.exists(model_path):
    print("Downloading model from Google Drive...")
    url = "plant_model/plant_disease_model.keras"
    gdown.download(url, model_path, quiet=False)
    print("Download completed!")

model = tf.keras.models.load_model(model_path)

## تحميل المودب الصغير
filter_model_path = "models/plant_detector_model.keras"
filter_model = tf.keras.models.load_model(filter_model_path)

def is_green_enough(img, green_threshold=0.02):
    try:
        img_array = np.array(img.resize((128, 128)))

        if img_array.shape[-1] != 3:
            return False

        red = img_array[:, :, 0].astype(np.float32)
        green = img_array[:, :, 1].astype(np.float32)
        blue = img_array[:, :, 2].astype(np.float32)

        green_pixels = (green > red + 5) & (green > blue + 5)

        # السماح بلون أصفر نباتي كعلامة مرض
        yellowish_pixels = (green > 100) & (red > 100) & (blue < 90)

        combined_mask = green_pixels | yellowish_pixels
        green_ratio = np.sum(combined_mask) / combined_mask.size

        print(f"🟢 نسبة اللون الأخضر أو الأصفر النباتي: {green_ratio * 100:.2f}%")

        return green_ratio > green_threshold

    except Exception as e:
        print(f"Error in is_green_enough: {e}")
        return False



# 🔹 دالة التحقق النهائية
def is_plant(img):
    try:
        # ✅ أولاً: فحص اللون الأخضر
        if not is_green_enough(img, green_threshold=0.05):
            print("❌ اللون الأخضر غير كافٍ")
            return False

        # ✅ ثانياً: التأكد من أبعاد الصورة للفلتر
        resized = img.resize((224, 224))
        img_array = image.img_to_array(resized)
        img_array = np.expand_dims(img_array, axis=0) / 255.0  # (1, 128, 128, 3)

        prediction = filter_model.predict(img_array)
        confidence = prediction[0][0]

        print(f"🤖 نسبة ثقة الموديل: {confidence:.2f}")
        return confidence > 0.3

    except Exception as e:
        print(f"Error in is_plant: {e}")
        return False

# أسماء الفئات مع الترجمة
class_labels = [
    {"en": ("Apple", "Apple Scab"), "ar": ("تفاح", "جرب التفاح")},
    {"en": ("Apple", "Black Rot"), "ar": ("تفاح", "عفن أسود")},
    {"en": ("Apple", "Cedar Apple Rust"), "ar": ("تفاح", "صدأ تفاح الأرز")},
    {"en": ("Apple", "Healthy"), "ar": ("تفاح", "سليم")},
    {"en": ("Blueberry", "Healthy"), "ar": ("توت أزرق", "سليم")},
    {"en": ("Cherry", "Powdery Mildew"), "ar": ("كرز", "البياض الدقيقي")},
    {"en": ("Cherry", "Healthy"), "ar": ("كرز", "سليم")},
    {"en": ("Corn", "Cercospora Leaf Spot / Gray Leaf Spot"), "ar": ("ذرة", "بقع أوراق سيركوسبورا")},
    {"en": ("Corn", "Common Rust"), "ar": ("ذرة", "الصدأ الشائع")},
    {"en": ("Corn", "Northern Leaf Blight"), "ar": ("ذرة", "لفحة الأوراق الشمالية")},
    {"en": ("Corn", "Healthy"), "ar": ("ذرة", "سليم")},
    {"en": ("Grape", "Black Rot"), "ar": ("عنب", "العفن الأسود")},
    {"en": ("Grape", "Esca (Black Measles)"), "ar": ("عنب", "إيسكا (الحصبة السوداء)")},
    {"en": ("Grape", "Leaf Blight (Isariopsis Leaf Spot)"), "ar": ("عنب", "لفحة الأوراق")},
    {"en": ("Grape", "Healthy"), "ar": ("عنب", "سليم")},
    {"en": ("Orange", "Haunglongbing (Citrus Greening)"), "ar": ("برتقال", "التخضير الحمضي")},
    {"en": ("Peach", "Bacterial Spot"), "ar": ("خوخ", "بقعة بكتيرية")},
    {"en": ("Peach", "Healthy"), "ar": ("خوخ", "سليم")},
    {"en": ("Pepper", "Bacterial Spot"), "ar": ("فلفل", "بقعة بكتيرية")},
    {"en": ("Pepper", "Healthy"), "ar": ("فلفل", "سليم")},
    {"en": ("Potato", "Early Blight"), "ar": ("بطاطس", "اللفحة المبكرة")},
    {"en": ("Potato", "Late Blight"), "ar": ("بطاطس", "اللفحة المتأخرة")},
    {"en": ("Potato", "Healthy"), "ar": ("بطاطس", "سليم")},
    {"en": ("Raspberry", "Healthy"), "ar": ("توت العليق", "سليم")},
    {"en": ("Soybean", "Healthy"), "ar": ("فول صويا", "سليم")},
    {"en": ("Squash", "Powdery Mildew"), "ar": ("قرع", "البياض الدقيقي")},
    {"en": ("Strawberry", "Leaf Scorch"), "ar": ("فراولة", "احتراق الأوراق")},
    {"en": ("Strawberry", "Healthy"), "ar": ("فراولة", "سليم")},
    {"en": ("Tomato", "Bacterial Spot"), "ar": ("طماطم", "بقعة بكتيرية")},
    {"en": ("Tomato", "Early Blight"), "ar": ("طماطم", "اللفحة المبكرة")},
    {"en": ("Tomato", "Late Blight"), "ar": ("طماطم", "اللفحة المتأخرة")},
    {"en": ("Tomato", "Leaf Mold"), "ar": ("طماطم", "عفن الأوراق")},
    {"en": ("Tomato", "Septoria Leaf Spot"), "ar": ("طماطم", "بقع أوراق سبتوريا")},
    {"en": ("Tomato", "Spider Mites"), "ar": ("طماطم", "العنكبوت الأحمر")},
    {"en": ("Tomato", "Target Spot"), "ar": ("طماطم", "بقعة الهدف")},
    {"en": ("Tomato", "Tomato Yellow Leaf Curl Virus"), "ar": ("طماطم", "فيروس تجعد أوراق الطماطم")},
    {"en": ("Tomato", "Tomato Mosaic Virus"), "ar": ("طماطم", "فيروس موزاييك الطماطم")},
    {"en": ("Tomato", "Healthy"), "ar": ("طماطم", "سليم")},
]

# Treatment advice
disease_treatment = {
    0: {
        "ar": "قم بإزالة الأوراق المصابة واستخدام مبيد فطري مناسب مثل الكبريت الميكروني.",
        "en": "Remove infected leaves and apply a suitable fungicide such as micronized sulfur."
    },
    1: {
        "ar": "اهتم بتهوية جيدة للشجرة واستخدم مبيدات فطرية مثل المانكوزيب.",
        "en": "Ensure proper tree ventilation and apply fungicides like Mancozeb."
    },
    2: {
        "ar": "أزل الفروع المصابة وحافظ على التهوية ورش مبيد مثل Myclobutanil.",
        "en": "Prune infected branches, ensure air circulation, and spray a fungicide like Myclobutanil."
    },
    5: {
        "ar": "حسن التهوية ورش مبيد فطري عضوي مثل الكبريت.",
        "en": "Improve air circulation and spray an organic fungicide such as sulfur."
    },
    7: {
        "ar": "قلل من الرطوبة ورش مبيد مثل Chlorothalonil.",
        "en": "Reduce humidity and apply a fungicide such as Chlorothalonil."
    },
    9: {
        "ar": "استخدم مبيدات وقائية مثل Pyraclostrobin وزرع أصناف مقاومة.",
        "en": "Use preventive fungicides like Pyraclostrobin and plant resistant varieties."
    },
    11: {
        "ar": "أزل الأوراق المصابة وزود التهوية ورش مبيد مناسب.",
        "en": "Remove infected leaves, improve ventilation, and apply a suitable fungicide."
    },
    13: {
        "ar": "أزل الأجزاء المصابة فوراً ورش مبيد فطري مثل Mancozeb.",
        "en": "Remove infected parts immediately and apply a fungicide like Mancozeb."
    },
    15: {
        "ar": "أزل الأشجار المصابة وتابع مكافحة الحشرات الناقلة.",
        "en": "Remove infected trees and control the insect vectors."
    },
    16: {
        "ar": "استخدم مبيدات نحاسية واهتم بالتسميد المتوازن.",
        "en": "Apply copper-based bactericides and ensure balanced fertilization."
    },
    20: {
        "ar": "استخدم دورة زراعية ورش مبيد وقائي مثل Chlorothalonil.",
        "en": "Practice crop rotation and apply a preventive fungicide like Chlorothalonil."
    },
    21: {
        "ar": "التخلص من الأوراق المصابة ورش مبيد مثل Metalaxyl.",
        "en": "Remove infected leaves and spray a fungicide like Metalaxyl."
    },
    34: {
        "ar": "أزل النباتات المصابة وراقب انتشار الحشرات الناقلة.",
        "en": "Remove infected plants and monitor insect vectors."
    },
    35: {
        "ar": "قلل من الأدوات الملوثة وازرع أصناف مقاومة.",
        "en": "Minimize contaminated tools and grow resistant varieties."
    },
    31: {
        "ar": "قلل الرطوبة واستخدم مبيد فطري فعال مثل Chlorothalonil.",
        "en": "Reduce humidity and apply an effective fungicide like Chlorothalonil."
    },
    32: {
        "ar": "حسن التهوية وأزل الأوراق السفلية المصابة.",
        "en": "Improve air circulation and remove infected lower leaves."
    },
    33: {
        "ar": "اغسل الأوراق بانتظام واستخدم مبيد مخصص للعناكب مثل Abamectin.",
        "en": "Wash leaves regularly and apply a miticide like Abamectin."
    },
    34: {
        "ar": "استخدم مبيد فطري وتجنب الري فوق الأوراق.",
        "en": "Apply fungicide and avoid overhead irrigation."
    },
    12: {
        "ar": "أزل الفروع المصابة فوراً ورش برنامج مكافحة مناسب.",
        "en": "Prune infected branches immediately and apply a proper control program."
    },
    3: {
        "ar": "النبات سليم ولا يحتاج إلى علاج.",
        "en": "The plant is healthy and does not require treatment."
    },
    4: {
        "ar": "النبات سليم ولا يحتاج إلى علاج.",
        "en": "The plant is healthy and does not require treatment."
    },
    6: {
        "ar": "النبات سليم ولا يحتاج إلى علاج.",
        "en": "The plant is healthy and does not require treatment."
    },
    10: {
        "ar": "النبات سليم ولا يحتاج إلى علاج.",
        "en": "The plant is healthy and does not require treatment."
    },
    14: {
        "ar": "النبات سليم ولا يحتاج إلى علاج.",
        "en": "The plant is healthy and does not require treatment."
    },
    17: {
        "ar": "النبات سليم ولا يحتاج إلى علاج.",
        "en": "The plant is healthy and does not require treatment."
    },
    19: {
        "ar": "النبات سليم ولا يحتاج إلى علاج.",
        "en": "The plant is healthy and does not require treatment."
    },
    22: {
        "ar": "النبات سليم ولا يحتاج إلى علاج.",
        "en": "The plant is healthy and does not require treatment."
    },
    23: {
        "ar": "النبات سليم ولا يحتاج إلى علاج.",
        "en": "The plant is healthy and does not require treatment."
    },
    24: {
        "ar": "النبات سليم ولا يحتاج إلى علاج.",
        "en": "The plant is healthy and does not require treatment."
    },
    27: {
        "ar": "النبات سليم ولا يحتاج إلى علاج.",
        "en": "The plant is healthy and does not require treatment."
    },
    36: {
        "ar": "النبات سليم ولا يحتاج إلى علاج.",
        "en": "The plant is healthy and does not require treatment."
    }
}
error_messages = {
    "no_file": {"en": "No file uploaded.", "ar": "لم يتم رفع أي ملف."},
    "no_selection": {"en": "No file selected.", "ar": "لم يتم اختيار أي ملف."},
    "not_plant": {"en": "Invalid image. Please upload a leaf image.", "ar": "الصورة غير صالحة. من فضلك ارفع صورة لورقة نبات."},
    "prediction_failed": {"en": "Prediction failed.", "ar": "فشل في التنبؤ."},
    "general_error": {"en": "An error occurred during prediction.", "ar": "حدث خطأ أثناء التنبؤ."}
}


def predict_image(file):
    try:
        img_bytes = io.BytesIO(file.read())
        img = Image.open(img_bytes).convert('RGB')

        # تحقق: هل الصورة فعلاً ورقة نبات؟
        if not is_plant(img):
            return "not_plant", None

        img = img.resize((256, 256))
        img_array = image.img_to_array(img)
        img_array = np.expand_dims(img_array, axis=0) / 255.0

        predictions = model.predict(img_array)
        predicted_class = np.argmax(predictions, axis=1)[0]
        confidence = predictions[0][predicted_class] * 100

        return predicted_class, confidence

    except Exception as e:
        print(f"Error in predict_image: {e}")
        return None, None

@app.route('/predict', methods=['POST'])
def predict():
    lang = request.args.get('lang', 'en')
    if 'file' not in request.files:
        return jsonify({'error': error_messages["no_file"].get(lang, error_messages["no_file"]["en"])}), 400

    file = request.files['file']
    if file.filename == '':
        return jsonify({'error': error_messages["no_selection"].get(lang, error_messages["no_selection"]["en"])}), 400

    try:
        predicted_class, confidence = predict_image(file)

        if predicted_class is None:
            return jsonify({'error': error_messages["prediction_failed"].get(lang, error_messages["prediction_failed"]["en"])}), 500

        if predicted_class == "not_plant":
            return jsonify({'error': error_messages["not_plant"].get(lang, error_messages["not_plant"]["en"])}), 400

        label = class_labels[predicted_class][lang]


        treatment = disease_treatment.get(predicted_class, {}).get(lang, "No treatment information available.")

        response = {
            "plant": label[0],
            "disease": label[1],
            "confidence": f"{confidence:.2f}%",
            "treatment": treatment
        }

        return jsonify(response)

    except Exception as e:
        print(f"Error in /predict route: {e}")
        return jsonify({'error': error_messages["general_error"].get(lang, error_messages["general_error"]["en"])}), 500



if __name__ == '__main__':
    app.run(debug=True, host='0.0.0.0', port=5000)
