import { useState } from "react";
import { MobileFrame } from "@/components/MobileFrame";
import { BottomNav, Tab } from "@/components/BottomNav";
import { HomeScreen } from "@/screens/HomeScreen";
import { WorkoutScreen } from "@/screens/WorkoutScreen";
import { NutritionScreen } from "@/screens/NutritionScreen";
import { CoachesScreen } from "@/screens/CoachesScreen";
import { ProfileScreen } from "@/screens/ProfileScreen";
import { AuthScreen } from "@/screens/AuthScreen";
import { OnboardingFlow } from "@/screens/OnboardingFlow";
import { RolePicker } from "@/screens/RolePicker";
import { CreatorOnboarding } from "@/screens/CreatorOnboarding";
import { ProgressDetailScreen } from "@/screens/ProgressDetailScreen";
import { StreakDetailsScreen } from "@/screens/StreakDetailsScreen";
import { ActiveWorkout } from "@/screens/ActiveWorkout";
import { AppProvider, useApp } from "@/store/app-store";
import { AuthProvider, useAuth } from "@/store/auth-store";
import { PremiumProvider } from "@/store/premium-store";
import { PaywallModal } from "@/components/PaywallModal";
import { Loader2, Award, X } from "lucide-react";

const UnlockOverlay = () => {
  const { recentlyUnlocked, dismissUnlock } = useApp();
  if (!recentlyUnlocked) return null;
  return (
    <div
      onClick={dismissUnlock}
      className="absolute inset-0 z-[60] bg-background/80 backdrop-blur-sm flex items-center justify-center p-6 animate-fade-up"
    >
      <div className="relative w-full max-w-xs rounded-3xl p-6 bg-gradient-to-br from-primary to-primary-glow text-white text-center shadow-glow">
        <button onClick={dismissUnlock} className="absolute top-3 right-3 w-8 h-8 rounded-full bg-white/15 flex items-center justify-center" aria-label="Dismiss">
          <X size={16} />
        </button>
        <div className="w-20 h-20 mx-auto rounded-3xl bg-white/15 flex items-center justify-center mb-4 animate-pulse-glow">
          <Award size={40} />
        </div>
        <p className="text-[10px] font-bold uppercase tracking-wider opacity-80">Achievement unlocked</p>
        <p className="text-2xl font-bold font-display mt-1">{recentlyUnlocked.title}</p>
        <p className="text-sm opacity-90 mt-1">{recentlyUnlocked.description}</p>
        <button
          onClick={dismissUnlock}
          className="mt-5 w-full h-11 rounded-2xl bg-white text-primary font-bold"
        >
          Nice
        </button>
      </div>
    </div>
  );
};

const AppShell = () => {
  const [tab, setTab] = useState<Tab>("home");
  const [workoutInitialView, setWorkoutInitialView] = useState<"home" | "history">("home");
  const [overlay, setOverlay] = useState<null | "progress" | "streak" | "active" | "active-resume" | "active-suggested">(null);
  const { session, loading, profile, refreshProfile } = useAuth();

  if (loading) {
    return (
      <MobileFrame>
        <div className="h-full flex items-center justify-center">
          <Loader2 className="animate-spin text-primary" size={28} />
        </div>
      </MobileFrame>
    );
  }

  if (!session) {
    return (
      <MobileFrame>
        <AuthScreen />
      </MobileFrame>
    );
  }

  if (profile && !profile.onboarded) {
    return (
      <MobileFrame>
        <OnboardingGate onDone={() => refreshProfile()} />
      </MobileFrame>
    );
  }


  return (
    <MobileFrame>
      <ShellContent
        tab={tab}
        setTab={setTab}
        overlay={overlay}
        setOverlay={setOverlay}
        workoutInitialView={workoutInitialView}
        setWorkoutInitialView={setWorkoutInitialView}
      />
      <UnlockOverlay />
      <PaywallModal />
    </MobileFrame>
  );
};

// Wraps onboarding so the user can pick athlete vs creator path first.
const OnboardingGate = ({ onDone }: { onDone: () => void }) => {
  const [role, setRole] = useState<null | "user" | "creator">(null);
  const { saveTemplate, setTodayTemplate } = useApp();

  const handleAthleteDone = async () => {
    // Auto-apply pending referral creator's default program (if any).
    try {
      const {
        getPendingReferralCreator, setPendingReferralCreator,
        fetchCreator, fetchDefaultSplit, splitToTemplates,
      } = await import("@/lib/creators");
      const creatorId = getPendingReferralCreator();
      if (creatorId) {
        const [creator, split] = await Promise.all([
          fetchCreator(creatorId),
          fetchDefaultSplit(creatorId),
        ]);
        if (creator && split) {
          const templates = splitToTemplates(creator, split);
          templates.forEach((t) => saveTemplate(t));
          if (templates[0]) setTodayTemplate(templates[0].id);
          const { supabase } = await import("@/integrations/supabase/client");
          const { data } = await supabase.auth.getSession();
          if (data.session?.user) {
            await Promise.all([
              supabase.from("profiles").update({ active_split_id: split.id }).eq("id", data.session.user.id),
              supabase.from("referrals").update({ applied: true })
                .eq("user_id", data.session.user.id).eq("creator_id", creatorId),
            ]);
          }
          const { toast } = await import("@/hooks/use-toast");
          toast({
            title: `You're now training with ${creator.name}`,
            description: `${split.name} is set as your active program.`,
          });
        }
        setPendingReferralCreator(null);
      }
    } catch {
      // non-fatal
    }
    onDone();
  };

  if (role === null) {
    return <RolePicker onPickUser={() => setRole("user")} onPickCreator={() => setRole("creator")} />;
  }
  if (role === "creator") {
    return (
      <CreatorOnboarding
        onCancel={() => setRole(null)}
        onDone={async () => {
          const { supabase } = await import("@/integrations/supabase/client");
          const { data } = await supabase.auth.getSession();
          if (data.session?.user) {
            await supabase.from("profiles").update({ onboarded: true }).eq("id", data.session.user.id);
          }
          onDone();
        }}
      />
    );
  }
  return <OnboardingFlow onDone={handleAthleteDone} />;
};

const ShellContent = ({
  tab, setTab, overlay, setOverlay, workoutInitialView, setWorkoutInitialView,
}: {
  tab: Tab;
  setTab: (t: Tab) => void;
  overlay: null | "progress" | "streak" | "active" | "active-resume" | "active-suggested";
  setOverlay: (o: null | "progress" | "streak" | "active" | "active-resume" | "active-suggested") => void;
  workoutInitialView: "home" | "history";
  setWorkoutInitialView: (v: "home" | "history") => void;
}) => {
  const { suggestedTemplate, todayTemplate } = useApp();

  if (overlay === "active" || overlay === "active-resume" || overlay === "active-suggested") {
    const tpl =
      overlay === "active-suggested" ? suggestedTemplate :
      overlay === "active" ? todayTemplate :
      null;
    return (
      <>
        <div className="h-full overflow-y-auto scrollbar-hide pb-24">
          <ActiveWorkout
            template={tpl}
            resume={overlay === "active-resume"}
            onFinish={() => setOverlay(null)}
          />
        </div>
        <BottomNav active={tab} onChange={(t) => { setOverlay(null); setTab(t); }} />
      </>
    );
  }

  if (overlay === "progress") {
    return (
      <>
        <div className="h-full overflow-y-auto scrollbar-hide pb-24">
          <ProgressDetailScreen onBack={() => setOverlay(null)} />
        </div>
        <BottomNav active={tab} onChange={(t) => { setOverlay(null); setTab(t); }} />
      </>
    );
  }

  if (overlay === "streak") {
    return (
      <>
        <div className="h-full overflow-y-auto scrollbar-hide pb-24">
          <StreakDetailsScreen onBack={() => setOverlay(null)} />
        </div>
        <BottomNav active={tab} onChange={(t) => { setOverlay(null); setTab(t); }} />
      </>
    );
  }

  return (
    <>
      <div key={tab} className="h-full overflow-y-auto scrollbar-hide pb-24 animate-fade-up">
        {tab === "home" && (
          <HomeScreen
            onStartWorkout={() => setOverlay("active")}
            onResumeWorkout={() => setOverlay("active-resume")}
            onStartSuggested={() => setOverlay("active-suggested")}
            onChoosePlan={() => { setWorkoutInitialView("home"); setTab("workout"); }}
            onOpenProgress={() => setOverlay("progress")}
            onOpenStreak={() => setOverlay("streak")}
            onOpenWorkoutHistory={() => { setWorkoutInitialView("history"); setTab("workout"); }}
            onOpenProfile={() => setTab("profile")}
            onQuickAction={(a) => setTab(a === "meal" ? "nutrition" : "workout")}
          />
        )}
        {tab === "workout" && <WorkoutScreen initialView={workoutInitialView} />}
        {tab === "nutrition" && <NutritionScreen />}
        {tab === "coaches" && <CoachesScreen />}
        {tab === "profile" && (
          <ProfileScreen
            onOpenWorkoutHistory={() => { setWorkoutInitialView("history"); setTab("workout"); }}
            onOpenStreak={() => setOverlay("streak")}
            onOpenNutrition={() => setTab("nutrition")}
            onOpenCoaches={() => setTab("coaches")}
          />
        )}
      </div>
      <BottomNav active={tab} onChange={setTab} />
    </>
  );
};

const Index = () => (
  <AuthProvider>
    <AppProvider>
      <PremiumProvider>
        <AppShell />
      </PremiumProvider>
    </AppProvider>
  </AuthProvider>
);

export default Index;
