
#import <UIKit/UIKit.h>

@interface UIView (Frame)

@property (assign, nonatomic) CGFloat x;/**< 起始x值 */
@property (assign, nonatomic) CGFloat y;/**< 起始y值 */
@property (assign, nonatomic) CGPoint origin;/**< 起始点坐标 */

@property (assign, nonatomic) CGFloat middleX;/**< 中点x值 */
@property (assign, nonatomic) CGFloat middleY;/**< 中点y值 */

@property (assign, nonatomic) CGFloat tail;  /**< 最大x值 */
@property (assign, nonatomic) CGFloat bottom;/**< 最大y值 */

@property (assign, nonatomic) CGFloat width; /**< 宽度 */
@property (assign, nonatomic) CGFloat height;/**< 高度 */
@property (assign, nonatomic) CGSize  size;  /**< 尺寸 */

@end
