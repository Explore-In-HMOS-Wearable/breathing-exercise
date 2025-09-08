import { ArcList, ArcListAttribute, ArcListItem, LengthUnit } from '@kit.ArkUI'
import { TextModifier } from '../modifier/TextModifier'

@Entry
@Component
struct Index {
  @State textModifier: TextModifier = new TextModifier();

  @Builder
  CustomListItem(title: string, onClick?: () => void) {
    ArcListItem() {
      Row() {
        Text(title)
          .attributeModifier(this.textModifier)
      }
      .width('80%')
      .justifyContent(FlexAlign.Center)
      .borderRadius(20)
      .backgroundColor('#a171cb5b')
      .height(30)
      .padding({ right: 8, left: 8 })
      .onClick(() => {
        if (onClick) {
          onClick()
        }
      })
    }
  }

  build() {
    RelativeContainer() {

      ArcList({ initialIndex: 1 }) {
        ArcListItem() {
          Text('Breathing Exercises').fontSize(16).fontColor(Color.White).fontWeight(FontWeight.Bold)
        }
        this.CustomListItem('Start', () => this.getUIContext().getRouter().pushUrl({
          url: 'pages/Main'
        }))
        this.CustomListItem('Settings', () => this.getUIContext().getRouter().pushUrl({
          url: 'pages/Settings'
        })
        )
      }.space({
        unit: LengthUnit.VP,
        value: 8
      })
    }
    .height('100%')
    .width('100%')
    .backgroundColor('#ff358027')
  }
}