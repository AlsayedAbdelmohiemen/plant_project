from tensorflow.keras import layers, models
from tensorflow.keras.preprocessing.image import ImageDataGenerator
from tensorflow.keras.callbacks import EarlyStopping, ModelCheckpoint
import os

# إعداد المسارات
base_dir = "plant_classifier_data"
img_size = (128, 128)
batch_size = 16

# إنشاء مجلد لحفظ النماذج إن لم يكن موجود
os.makedirs("models", exist_ok=True)

# تجهيز البيانات مع Augmentation
datagen = ImageDataGenerator(
    rescale=1./255,
    rotation_range=15,
    zoom_range=0.2,
    horizontal_flip=True,
    width_shift_range=0.1,
    height_shift_range=0.1,
    validation_split=0.2
)

train_gen = datagen.flow_from_directory(
    base_dir,
    target_size=img_size,
    batch_size=batch_size,
    class_mode='binary',
    subset='training',
    shuffle=True
)

val_gen = datagen.flow_from_directory(
    base_dir,
    target_size=img_size,
    batch_size=batch_size,
    class_mode='binary',
    subset='validation',
    shuffle=False
)

# بناء الموديل
model = models.Sequential([
    layers.Input(shape=(128, 128, 3)),
    layers.Conv2D(32, (3, 3), activation='relu'),
    layers.MaxPooling2D(),

    layers.Conv2D(64, (3, 3), activation='relu'),
    layers.MaxPooling2D(),

    layers.Conv2D(128, (3, 3), activation='relu'),
    layers.MaxPooling2D(),

    layers.Flatten(),
    layers.Dense(64, activation='relu'),
    layers.Dropout(0.3),
    layers.Dense(1, activation='sigmoid')
])

# تجميع الموديل
model.compile(optimizer='adam',
              loss='binary_crossentropy',
              metrics=['accuracy'])

# كولباك لحفظ أفضل موديل والتوقف المبكر
callbacks = [
    EarlyStopping(patience=5, restore_best_weights=True),
    ModelCheckpoint("plant_model/models/plant_detector_model.keras", save_best_only=True)
]

# تدريب الموديل
history = model.fit(
    train_gen,
    validation_data=val_gen,
    epochs=20,
    callbacks=callbacks
)

# تقييم الأداء
loss, acc = model.evaluate(val_gen)
print(f"✅ معدل الدقة النهائية على بيانات التحقق: {acc * 100:.2f}%")
