export class TextModifier implements AttributeModifier<TextAttribute> {
  applyNormalAttribute(instance: TextAttribute): void {
    instance.fontColor(Color.White)
      .fontWeight(FontWeight.Bold)
      .fontSize(18);
  }
}