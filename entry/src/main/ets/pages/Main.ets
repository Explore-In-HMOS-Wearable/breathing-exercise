import lottie, { AnimationItem } from '@ohos/lottie';
import { ArcButton, ArcButtonOptions, ArcButtonPosition } from '@ohos.arkui.advanced.ArcButton';
import { ArcButtonStyleMode, ButtonOptions, promptAction } from '@kit.ArkUI';

@Entry
@ComponentV2
struct Main {
  private renderingSettings: RenderingContextSettings = new RenderingContextSettings(true)
  private canvasRenderingContext: CanvasRenderingContext2D = new CanvasRenderingContext2D(this.renderingSettings)
  private animateItem: AnimationItem | null = null;
  private animateName: string = "animation"; // name
  private timeOut: null | number = null
  @Local isStarted: boolean = false;
  @Local options: ArcButtonOptions | undefined = new ArcButtonOptions({})
  @Local speed: number = AppStorage.get('speed') as number;

  aboutToAppear(): void {
    this.initButton()
  }

  // Destroy the animation.
  aboutToDisappear(): void {
    console.info('aboutToDisappear');
    lottie.destroy();
    clearTimeout(this.timeOut);
  }

  initButton() {
    this.options = new ArcButtonOptions({
      label: this.isStarted ? 'Stop' : 'Start',
      position: ArcButtonPosition.BOTTOM_EDGE,
      styleMode: ArcButtonStyleMode.NORMAL_LIGHT,
      onClick: () => {
        if (this.isStarted) {
          this.stop()
        } else {
          this.start()
        }
      }
    })
  }

  stop() {
    this.animateItem?.stop()
    this.isStarted = false;
    this.initButton()
  }

  start() {
    this.animateItem?.play()
    this.isStarted = true
    const time: number = AppStorage.get('time') as number
    this.initButton()
    this.timeOut = setTimeout(() => {
      this.animateItem?.stop()
      this.isStarted = false;
      this.initButton()
    }, time * 60000)
  }

  @Builder
  StartButton() {
    ArcButton({
      options: this.options
    })
      .alignRules({
        middle: { anchor: '__container__', align: HorizontalAlign.Center },
        bottom: { anchor: '__container__', align: VerticalAlign.Bottom }
      })
  }

  build() {
    Flex({ direction: FlexDirection.Column, alignItems: ItemAlign.Center, justifyContent: FlexAlign.Center }) {
      Row() {
        Canvas(this.canvasRenderingContext)
          .width('100%')
          .height('100%')
          .backgroundColor(Color.White)
          .onReady(() => {
            // Load the animation.
            if (this.animateItem != null) {
              // Load animations during canvas onReady, ensure that the animation size is correct.
              this.animateItem?.resize();

            } else {
              // Anti-aliasing settings.
              this.canvasRenderingContext.imageSmoothingEnabled = true;
              this.canvasRenderingContext.imageSmoothingQuality = 'high'
              this.loadAnimation();
            }
          })
      }.width('100%').justifyContent(FlexAlign.Center).backgroundColor('#aaa')

      if (this.isStarted) {
        this.StartButton()
      } else {
        this.StartButton()
      }

    }
    .width('100%')
    .height('100%')
    .backgroundColor(Color.White)
  }

  loadAnimation() {
    this.animateItem = lottie.loadAnimation({
      container: this.canvasRenderingContext,
      renderer: 'canvas', // canvas renderer
      loop: true,
      autoplay: false,
      name: this.animateName,
      contentMode: 'Contain',
      path: "animation/Breath.json",
    })


    // Animations are loaded asynchronously, any operations on animateItem should be performed within the callback function for when the animation has finished loading.
    this.animateItem.addEventListener('DOMLoaded', (args: Object): void => {
      this.animateItem?.changeColor([225, 25, 100, 1]);
      this.animateItem?.setSpeed(this.speed);
      this.animateItem?.resize();
    });

  }

  destroy() {
    this.animateItem?.removeEventListener("DOMLoaded");
    lottie.destroy(this.animateName);
    this.animateItem = null;
  }
}