import { usePage } from '@inertiajs/react';
import { forwardRef } from 'react';
import type { AnchorHTMLAttributes, MouseEvent, ReactNode } from 'react';
import { resolveCtaEvent } from '@/analytics/event-types';
import type { CtaAction, CtaZone } from '@/analytics/event-types';
import { track } from '@/analytics/tracker';
import type { TrackingProps } from '@/types/analytics';

type Props = Omit<AnchorHTMLAttributes<HTMLAnchorElement>, 'onClick'> & {
    zone: CtaZone;
    action: CtaAction;
    label: string;
    children: ReactNode;
    onClick?: (event: MouseEvent<HTMLAnchorElement>) => void;
};

export const TrackedCTA = forwardRef<HTMLAnchorElement, Props>(function TrackedCTA(
    { zone, action, label, children, onClick, ...props },
    ref,
) {
    const tracking = usePage().props.tracking as TrackingProps;

    const handleClick = (event: MouseEvent<HTMLAnchorElement>) => {
        if (tracking?.enabled) {
            const eventType = resolveCtaEvent(tracking.mode, action);
            void track(eventType, { zone, action, cta_label: label });
        }

        onClick?.(event);
    };

    return (
        <a {...props} ref={ref} onClick={handleClick}>
            {children}
        </a>
    );
});
