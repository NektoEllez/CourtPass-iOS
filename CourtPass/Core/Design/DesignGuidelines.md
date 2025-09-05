# Design System Guidelines

Руководство по использованию дизайн-системы CourtPass для обеспечения консистентности и качества кода.

## 🎯 Основные принципы

1. **Никаких магических чисел** - используйте только токены из DesignTokens.swift
2. **Семантические названия** - предпочитайте семантические токены (`.lg`, `.cardPadding`) числовым (`.16`)
3. **Масштабируемость** - используйте базовую сетку 4pt для всех размеров
4. **Консистентность** - один токен для одинаковых случаев использования

## 📏 Spacing Guidelines

### Базовая система отступов
```swift
// ❌ НЕ ДЕЛАЙТЕ ТАК
.padding(16)
.padding(.horizontal, 24)

// ✅ ПРАВИЛЬНО
.padding(DesignTokens.Spacing.lg)
.padding(.horizontal, DesignTokens.Spacing.xxl)
```

### Таблица использования spacing токенов

| Токен | Значение | Когда использовать |
|-------|----------|-------------------|
| `xs` | 4pt | Минимальные отступы, между иконками в HStack |
| `sm` | 8pt | Маленькие отступы внутри компонентов, между элементами |
| `md` | 12pt | Средние отступы, стандартные padding для кнопок |
| `lg` | 16pt | Стандартные отступы экрана от краев |
| `xl` | 20pt | Большие отступы между секциями |
| `xxl` | 24pt | Очень большие отступы, bottom padding карточек |
| `xxxl` | 32pt | Максимальные отступы между major блоками |

### Семантические токены
```swift
// ❌ Неясные намерения
.padding(.horizontal, DesignTokens.Spacing.lg)

// ✅ Четкие намерения
.padding(.horizontal, DesignTokens.Spacing.screenPadding)
.padding(.vertical, DesignTokens.Spacing.cardPadding)
.padding(.top, DesignTokens.Spacing.sectionSpacing)
```

## 🎨 Color Guidelines

### Текстовые цвета
```swift
// ❌ НЕ ДЕЛАЙТЕ ТАК
.foregroundColor(.gray)
.foregroundColor(.black)

// ✅ ПРАВИЛЬНО
.foregroundColor(DesignTokens.Text.secondary)
.foregroundColor(DesignTokens.Text.primary)
```

### Семантические цвета
- `primary` - основной текст
- `secondary` - вторичный текст, подписи
- `tertiary` - еще менее важный текст
- `link` - ссылки и интерактивные элементы
- `disabled` - отключенные элементы
- `onDark` - текст на темном фоне
- `onLight` - текст на светлом фоне

## 📐 Size Guidelines

### Иконки
```swift
// ❌ Магические числа
.font(.system(size: 24))
.frame(width: 20, height: 20)

// ✅ Семантические токены
.font(.system(size: DesignTokens.IconSize.social))
.frame(width: DesignTokens.IconSize.button, height: DesignTokens.IconSize.button)
```

### Компоненты
```swift
// ❌ Хардкод размеров
.frame(width: 80, height: 120)

// ✅ Семантические размеры
.frame(width: DesignTokens.Size.categoryCardWidth, 
       height: DesignTokens.Size.categoryCardHeight)
```

## 🔄 Corner Radius Guidelines

### Использование радиусов
```swift
// ❌ Магические числа
.cornerRadius(12)
.cornerRadius(16)

// ✅ Семантические названия
.cornerRadius(DesignTokens.CornerRadius.button)
.cornerRadius(DesignTokens.CornerRadius.card)
```

### Таблица радиусов

| Токен | Значение | Применение |
|-------|----------|------------|
| `none` | 0pt | Прямоугольные элементы |
| `xs` | 4pt | Маленькие элементы |
| `sm` | 8pt | Input поля |
| `md` | 12pt | Кнопки |
| `lg` | 16pt | Карточки |
| `xl` | 20pt | Модальные окна |
| `pill` | 999pt | Pill-кнопки |

## 💫 Animation Guidelines

### Длительности анимаций
```swift
// ❌ Магические числа
.animation(.easeInOut(duration: 0.2))

// ✅ Семантические токены
.animation(DesignTokens.Animation.tabSelection)
.animation(.easeInOut(duration: DesignTokens.Animation.normal))
```

### Таблица длительностей

| Токен | Значение | Применение |
|-------|----------|------------|
| `fast` | 0.12s | Hover эффекты, мелкие изменения |
| `normal` | 0.2s | Стандартные переходы |
| `slow` | 0.3s | Сложные переходы |

## 🔍 Opacity Guidelines

```swift
// ❌ Магические числа
.opacity(0.3)
Color.black.opacity(0.1)

// ✅ Семантические токены
.opacity(DesignTokens.Opacity.disabled)
Color.black.opacity(DesignTokens.Opacity.loadingOverlay)
```

## 📝 Typography Guidelines

### Иерархия типографики
```swift
// ✅ Правильное использование
Text("Заголовок").font(DesignTokens.Typography.display)
Text("Подзаголовок").font(DesignTokens.Typography.title)  
Text("Основной текст").font(DesignTokens.Typography.body)
Text("Подпись").font(DesignTokens.Typography.caption)
```

### Fallback шрифты
При отсутствии кастомных шрифтов система автоматически переключится на fallback версии.

## 🚫 Что НЕ следует делать

### Магические числа
```swift
// ❌ Плохо
.padding(16)
.frame(height: 44) 
.cornerRadius(12)
.opacity(0.3)
```

### Хардкод цветов
```swift
// ❌ Плохо  
.foregroundColor(.gray)
.background(Color(hex: "#FF0000"))
```

### Дублирование значений
```swift
// ❌ Плохо
.padding(.top, 16)
.padding(.leading, 16)  

// ✅ Хорошо
.padding([.top, .leading], DesignTokens.Spacing.lg)
```

## ✅ Лучшие практики

### 1. Группируйте модификаторы
```swift
VStack {
    // content
}
.padding(DesignTokens.Spacing.cardPadding)
.background(DesignTokens.Card.background)
.cornerRadius(DesignTokens.CornerRadius.card)
```

### 2. Используйте View extensions
```swift
extension View {
    func cardStyle() -> some View {
        self
            .padding(DesignTokens.Spacing.cardPadding)
            .background(DesignTokens.Card.background) 
            .cornerRadius(DesignTokens.CornerRadius.card)
    }
}
```

### 3. Создавайте семантические модификаторы
```swift
// В DesignTokens.swift
extension View {
    func primaryButton() -> some View {
        self
            .font(DesignTokens.Typography.bodySemibold)
            .foregroundColor(DesignTokens.Text.onDark)
            .padding(.vertical, DesignTokens.Spacing.md)
            .padding(.horizontal, DesignTokens.Spacing.lg)
            .background(DesignTokens.Brand.primary)
            .cornerRadius(DesignTokens.CornerRadius.button)
    }
}
```

## 🔄 Миграция существующего кода

При рефакторинге старого кода:

1. **Найдите все магические числа** в файле
2. **Замените их на соответствующие токены**
3. **Используйте семантические названия** где возможно
4. **Проверьте консистентность** с остальным приложением

## 📊 Metrics и KPI

- ✅ 0 магических чисел в коде
- ✅ 100% использование токенов дизайн-системы
- ✅ Консистентные отступы на всех экранах
- ✅ Единообразная типографика

---

**Помните**: Хорошая дизайн-система - это инвестиция в будущее проекта. Потратьте время сейчас, сэкономьте его позже!
